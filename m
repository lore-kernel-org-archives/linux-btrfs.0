From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Single disk performance
Date: Fri, 26 Jun 2009 21:26:59 -0500
Message-ID: <4A458373.4010603@austin.ibm.com>
References: <4A44DB23.5000400@austin.ibm.com> <20090626205659.GD3951@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090626205659.GD3951@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, Jun 26, 2009 at 09:28:51AM -0500, Steven Pratt wrote:
>   
>> Upgraded the btrfs tree to 6-17 and all of the stability problems went  
>> away on the single disk system, so not sure if this was a code problem  
>> or hardware, but at least stable now.
>> Performance results updated at:
>> http://btrfs.boxacle.net/repository/single-disk/History/History.html
>>
>> The fixed to the cow path are obvious for random write, although even on  
>> single disk the CPU overhead is very noticeable as the efficiency graphs  
>> show.
>>
>> The good news is that now the only workload that Btrfs is not at or near  
>> the top in performance for single disk is MailServer.
>>     
>
> Thanks Steve, glad to hear the stability problems are gone.
>
>   
Well, maybe I spoke too soon. :-(    Run with this patch died in similar 
way to before.  My remote service console is not responding, so will 
probably be Monday before I can get to the lab to restart manually.


I am getting messages like:


8:36:13 btrfs2 kernel: [ 4200.909078] INFO: task ffsb:26362 blocked for 
more than 120 seconds.
Jun 26 18:36:13 btrfs2 kernel: [ 4200.915474] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 26 18:36:13 btrfs2 kernel: [ 4200.923338] ffsb          D 
ffffffff804e15e0     0 26362  26200
Jun 26 18:36:13 btrfs2 kernel: [ 4200.923346]  ffff8801263bdcc8 
0000000000000086 0000000000000000 ffff88004519d158
Jun 26 18:36:13 btrfs2 kernel: [ 4200.930914]  0000000000000000 
ffff88013b9cc710 ffff88013fbf96f0 ffff88013b9cca98
Jun 26 18:36:13 btrfs2 kernel: [ 4200.938489]  00000008263bdca8 
000000010039973e ffff8801263bdca8 ffff88012c95a600
Jun 26 18:36:13 btrfs2 kernel: [ 4200.946054] Call Trace:
Jun 26 18:36:13 btrfs2 kernel: [ 4200.948545]  [<ffffffff804cbe09>] 
schedule+0x9/0x1d
Jun 26 18:36:13 btrfs2 kernel: [ 4200.953459]  [<ffffffff804cc09c>] 
io_schedule+0x5d/0x9f
Jun 26 18:36:13 btrfs2 kernel: [ 4200.958718]  [<ffffffff8027c86e>] 
sync_page+0x44/0x48
Jun 26 18:36:13 btrfs2 kernel: [ 4200.963800]  [<ffffffff804cc3e6>] 
__wait_on_bit+0x45/0x77
Jun 26 18:36:13 btrfs2 kernel: [ 4200.969235]  [<ffffffff8027c82a>] ? 
sync_page+0x0/0x48
Jun 26 18:36:13 btrfs2 kernel: [ 4200.974408]  [<ffffffff8027c9fa>] 
wait_on_page_bit+0x6f/0x76
Jun 26 18:36:13 btrfs2 kernel: [ 4200.980107]  [<ffffffff8024c498>] ? 
wake_bit_function+0x0/0x2a
Jun 26 18:36:13 btrfs2 kernel: [ 4200.986050]  [<ffffffffa036c123>] 
prepare_pages+0xbd/0x1f3 [btrfs]
Jun 26 18:36:13 btrfs2 kernel: [ 4200.992281]  [<ffffffffa036c619>] 
btrfs_file_write+0x3c0/0x6d2 [btrfs]
Jun 26 18:36:13 btrfs2 kernel: [ 4200.998839]  [<ffffffff802ab7b8>] 
vfs_write+0xae/0x137
Jun 26 18:36:13 btrfs2 kernel: [ 4201.004351]  [<ffffffff802abcfd>] 
sys_write+0x47/0x6f
Jun 26 18:36:13 btrfs2 kernel: [ 4201.009773]  [<ffffffff8020ba2b>] 
system_call_fastpath+0x16/0x1b
Jun 26 18:36:13 btrfs2 kernel: [ 4201.016160] INFO: task ffsb:26366 
blocked for more than 120 seconds.
Jun 26 18:36:13 btrfs2 kernel: [ 4201.022894] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 26 18:36:13 btrfs2 kernel: [ 4201.031446] ffsb          D 
ffffffff804e15e0     0 26366  26200

Lots of these timeout messages, then eventually

 18:40:32 btrfs2 kernel: [ 4459.870613] sd 0:0:1:0: [sdb] Unhandled 
error code
Jun 26 18:40:32 btrfs2 kernel: [ 4459.870640] sd 0:0:1:0: [sdb] Result: 
hostbyte=DID_ABORT driverbyte=DRIVER_OK
Jun 26 18:40:32 btrfs2 kernel: [ 4459.870646] end_request: I/O error, 
dev sdb, sector 103359232

So still not sure if this is HW, but no other FS has triggered it.

Steve

> Could you please try this one liner to see if our big CPU problem during
> streaming writes goes away?
>   
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 126477e..7c3cd24 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -151,7 +151,10 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
>  	}
>  	if (end_pos > isize) {
>  		i_size_write(inode, end_pos);
> -		btrfs_update_inode(trans, root, inode);
> +		/* we've only changed i_size in ram, and we haven't updated
> +		 * the disk i_size.  There is no need to log the inode
> +		 * at this time.
> +		 */
>  	}
>  	err = btrfs_end_transaction(trans, root);
>  out_unlock:
>   

