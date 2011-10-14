From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: snapshot issues
Date: Fri, 14 Oct 2011 13:17:15 -0500
Message-ID: <4E987CAB.2000007@xtfx.me>
References: <4E986DBB.4080100@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E986DBB.4080100@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2011 12:13 PM, Jim wrote:
> Good afternoon btrfs,
> I have been having issues with snapshots not reading the whole file 
> tree below them.  I have installed new btrfs-progs from
>
> git://git.darksatanic.net/repo/btrfs-progs-unstable.git
>
> made and installed them.  My tree is:  /Btrfs |
>                                               |__ nfs1 |
>                                                        |__ data |
>                                                                 |__ 
> sites |
>                                                                           
> |__ 00xx |
>                                                                                    
> |__ email@address
>
> If I use btrfsctl -s (btrfs sub snapshot isn't working) snappath-name 
> /btrfs/nfs1  I get a mountable snapshot of nfs1
> but data is all that I can see below it.  If I btrfsctl -s 
> snappath-name /btrfs/nfs1/data/sites/0000 I can mount /0000 and
> get a full list of email@address accounts but none of the files below 
> them.  I should have stated earlier, everything down
> to and including /email@address are subvolumes.  Below /email@address 
> directories and files were rsync'd into the subvol from
> an nfs mount.  Finally if I snapshot /email@address I have access to 
> all directories and files below them.  Because of this I
> believe that the issue is with snapshots of subvolumes.  I thought I 
> just couldn't see subvols above the snapshot level and was able to see 
> subvols below.  Am I confused or is this a real problem.  I am using 
> kernel 3.1.0-rc4 and will be happy to trace anything you need if you 
> can tell me how to get what you need.  Thanks for your help.
> Jim
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

yaarg -- resend w/list included -- changed clients recently (tbird) and 
cant figure out how to default to replay-all ...

i believe this is expected behavior as of now -- there are a couple 
threads mentioning `recursive snapshotting`, check those out.  AFAIK a 
snapshot will not traverse beyond it's own boundaries.

-- 
C Anthony Risinger

