Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.demfloro.ru ([185.52.0.75]:36100 "EHLO mx.demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732699AbeHNQ22 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 12:28:28 -0400
Date: Tue, 14 Aug 2018 16:41:11 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: "Scott E. Blomquist" <sb@techsquare.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: trouble mounting btrfs filesystem....
Message-ID: <20180814164111.76653189@job.localdomain>
In-Reply-To: <23410.55756.949586.17718@techsquare.com>
References: <23408.34902.778845.675960@techsquare.com>
        <23410.52600.89620.15949@techsquare.com>
        <20180814160046.581c1de2@job.localdomain>
        <23410.55756.949586.17718@techsquare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Aug 2018 09:31:56 -0400
"Scott E. Blomquist" <sb@techsquare.com> wrote:

> Dmitrii Tcvetkov writes:
>  > > Scott E. Blomquist writes:  
>  > >  > Hi All,
>  > >  > 
>  > >  > Early this morning there was a power glitch that affected our
>  > >  > system.
>  > >  > 
>  > >  > The second enclosure went offline but the file system stayed
>  > >  > up for a bit before rebooting and recovering the 2 missing
>  > >  > arrays sdb1 and sdc1.
>  > >  > 
>  > >  > When mounting we get....
>  > >  > 
>  > >  >     Aug 12 14:52:43 localhost kernel: [ 8536.649270] BTRFS
>  > >  > info (device sda1): has skinny extents Aug 12 14:54:52
>  > >  > localhost kernel: [ 8665.900321] BTRFS error (device sda1):
>  > >  > parent transid verify failed on 177443463479296 wanted
>  > >  > 2159304 found 2159295 Aug 12 14:54:52 localhost kernel:
>  > >  > [ 8665.985512] BTRFS error (device sda1): parent transid
>  > >  > verify failed on 177443463479296 wanted 2159304 found 2159295
>  > >  > Aug 12 14:54:52 localhost kernel: [ 8666.056845] BTRFS error
>  > >  > (device sda1): failed to read block groups: -5 Aug 12
>  > >  > 14:54:52 localhost kernel: [ 8666.254178] BTRFS error (device
>  > >  > sda1): open_ctree failed
>  > >  > 
>  > >  > We are here...
>  > >  > 
>  > >  >     # uname -a
>  > >  >     Linux localhost 4.17.14-custom #1 SMP Sun Aug 12 11:54:00
>  > >  > EDT 2018 x86_64 x86_64 x86_64 GNU/Linux
>  > >  > 
>  > >  >     # btrfs --version
>  > >  >     btrfs-progs v4.17.1
>  > >  >     
>  > >  >     # btrfs filesystem show
>  > >  >     Label: none  uuid: 8337c837-58cb-430a-a929-7f6d2f50bdbb
>  > >  >             Total devices 3 FS bytes used 75.05TiB
>  > >  >             devid    1 size 47.30TiB used 42.07TiB
>  > >  > path /dev/sda1 devid    2 size 21.83TiB used 16.61TiB
>  > >  > path /dev/sdb1 devid    3 size 21.83TiB used 16.61TiB
>  > >  > path /dev/sdc1 
>  > >  > Thanks for any help.
>  > >  > 
>  > >  > sb. Scott Blomquist    
>  > > Hi All,
>  > > 
>  > > Is there any more info needed here?
>  > > 
>  > > I can restore from backup if needed but that will take a bit of
>  > > time.
>  > > 
>  > > Checking around it looks like I could try...
>  > > 
>  > >     btrfs-zero-log /dev/sda1
>  > > 
>  > > Or maybe ..
>  > > 
>  > >    btrfsck --repair /dev/sda1
>  > > 
>  > > I am just not sure here and would prefer to do the right thing.
>  > > 
>  > > Any help would be much appreciated.
>  > > 
>  > > Thanks,
>  > > 
>  > > sb. Scott Blomquist
>  > > 
>  > >   
>  > 
>  > I'm not a dev, just user.
>  > btrfs-zero-log is for very specific case[1], not for transid
>  > errors. Transid errors mean that some metadata writes are missing,
>  > if they prevent you from mounting filesystem it's pretty much
>  > fatal. If btrfs could recover metadata from good copy it'd have
>  > done that.
>  > 
>  > "wanted 2159304 found 2159295" means that some metadata is stale
>  > by 9 commits. You could try to mount it with "ro,usebackuproot"
>  > mount options as readonly mount is less strict. If that works you
>  > can try "usebackuproot" without ro option. But 9 commits is
>  > probably too much and there isn't enough data to rollback so far.
>  > 
>  > [1] https://btrfs.wiki.kernel.org/index.php/Btrfs-zero-log  
> 
> Thank you.  So zero-log is not the right thing...
> 
> Unfortunately when mounting ro,usebackuproot I still get the same
> messages...
> 
>     Aug 14 09:08:15 localhost kernel: [160669.100314] BTRFS info
> (device sda1): trying to use backup root at mount time Aug 14
> 09:08:15 localhost kernel: [160669.100316] BTRFS info (device sda1):
> using free space tree Aug 14 09:08:15 localhost kernel:
> [160669.100318] BTRFS info (device sda1): has skinny extents Aug 14
> 09:10:24 localhost kernel: [160797.736704] BTRFS error (device sda1):
> parent transid verify failed on 177443463479296 wanted 2159304 found
> 2159295 Aug 14 09:10:24 localhost kernel: [160797.815441] BTRFS error
> (device sda1): parent transid verify failed on 177443463479296 wanted
> 2159304 found 2159295 Aug 14 09:10:24 localhost kernel:
> [160797.887708] BTRFS error (device sda1): failed to read block
> groups: -5 Aug 14 09:10:24 localhost kernel: [160798.031183] BTRFS
> error (device sda1): open_ctree failed
> 
> it sounds like my only option maybe 'btrfs check --repair' and that
> doesn't sound too hopeful.
> 
> Any other ideas?
> 
> Thanks,
> 
> sb. Scott Blomquist

As far as I know btrfs check --repair doesn't fix transid errors.
Usually devs can tell whenever "btrfs check --repair" will repair
anything by looking at "btrfs check --readonly" output, but as your
filesystem is quite big this will take some time.

If usebackuproot doesn't help then filesystem is beyond repair and you
should try to refresh your backups with "btrfs restore" and restore from them[1].

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#How_do_I_recover_from_a_.22parent_transid_verify_failed.22_error.3F
