From: Martin Mailand <martin@tuxadero.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0
 [btrfs]()
Date: Fri, 16 Sep 2011 17:15:42 +0200
Message-ID: <4E73681E.4030205@tuxadero.com>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net> <20110915195029.GD25179@dhcp231-156.rdu.redhat.com> <4E735896.3000608@tuxadero.com> <4E735F16.7000303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4E735F16.7000303@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
the commit is not in there, but the code looks like your post.

if (--trans->use_count) {
                 trans->block_rsv = trans->orig_rsv;
                 return 0;
         }

         trans->block_rsv = NULL;
         while (count < 4) {
                 unsigned long cur = trans->delayed_ref_updates;
                 trans->delayed_ref_updates = 0;

But on the other hand I am quite new to git, how could I get your latest 
commit?

Best Regards,
  Martin

Am 16.09.2011 16:37, schrieb Josef Bacik:
> On 09/16/2011 10:09 AM, Martin Mailand wrote:
>> Hi Josef,
>> after a quick test it seems that I do not hit this Warning any longer.
>> But I got a new one.
>>
>
> Hmm looks like that may not be my newest stuff, is commit
>
> 57f499e1bb76ba3ebeb09cd12e9dac84baa5812b
>
> in there?  Specifically look at __btrfs_end_transaction in transaction.c
> and see if the line
>
> trans->block_rsv = NULL;
>
> is before the first while() loop.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

