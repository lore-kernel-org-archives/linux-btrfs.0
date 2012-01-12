From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
Date: Thu, 12 Jan 2012 09:16:44 +0800
Message-ID: <4F0E347C.5040506@cn.fujitsu.com>
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com> <20120111114544.GE14423@infradead.org> <alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/11/2012 08:14 PM, Lukas Czerner wrote:
> On Wed, 11 Jan 2012, Christoph Hellwig wrote:
> 
>> On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
>>> When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
>>> cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
>>>
>>> With this patch, 251 has passed.
>> Why would cp give that message with a missing /?
>>
>> I'm not against putting this in, but I'd like to understand what's going
>> on.
>>
>> Lukas, any idea?
>>
> 
> Hi Christoph,
> 
> the only reason I can think of is probably that Liu is accessing the
> xfstests directory via symbolic link, hence the '$content' addresses the
> symbolic link and cp is trying to overwrite the directory with
> non-directory (symlink).
> 
> The fix is fine for both cases (xfstests as symlink and directory), confirmed
> with a simple test.
> 

Sorry for not showing the full story in changelog, but symbolic link is the point:

[root@kvm tmp]# ll XFStests 
lrwxrwxrwx 1 root root 32 Jan  1 09:48 XFStests -> /home/kvm_img/liub/xfstests-dev/

thanks,
liubo

> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

