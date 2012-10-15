Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:55123 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2JORCP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 13:02:15 -0400
Message-ID: <507C41A4.7020103@alice.it>
Date: Mon, 15 Oct 2012 19:02:28 +0200
From: Goffredo Baroncelli <kreijack@alice.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Chris Mason <chris.mason@fusionio.com>, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH][V1][BTRFS-PROGS] Replace the units from KB to KiB..
References: <1350156436-14439-1-git-send-email-kreijack@gmail.com> (sfid-20121014_015034_115476_F3498551) <201210151358.46677.Martin@lichtvoll.de>
In-Reply-To: <201210151358.46677.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

thanks for your testing.
My patches are based on the Chris's master branch  
(git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git, 
commit
91d9eec1ff044394f2b98ee7fcb76713dd33b994).

I was able to apply both without problem.
disk_free cannot be the source of the problem because it doesn't touch 
utils.c.

I tryed to pull from my repo,

ghigo@venice:/tmp$ git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
Cloning into 'btrfs-progs'...
remote: Counting objects: 2692, done.
remote: Compressing objects: 100% (894/894), done.
remote: Total 2692 (delta 2015), reused 2380 (delta 1794)
Receiving objects: 100% (2692/2692), 819.72 KiB | 83 KiB/s, done.
Resolving deltas: 100% (2015/2015), done.
ghigo@venice:/tmp$ cd btrfs-progs/
ghigo@venice:/tmp/btrfs-progs$ git fetch 
http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git unit:unit
ghigo@venice:/tmp/btrfs-progs$ git fetch 
http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git 
disk_free:disk_free
 From http://cassiopea.homelinux.net/git/btrfs-progs-unstable
  * [new branch]      disk_free  -> disk_free
ghigo@venice:/tmp/btrfs-progs$ git branch
   disk_free
* master
   unit
ghigo@venice:/tmp/btrfs-progs$ git merge -m "Merge branches" disk_free unit
Fast-forwarding to: disk_free
Trying simple merge with unit
Simple merge did not work, trying automatic merge.
Auto-merging cmds-filesystem.c
Auto-merging man/btrfs.8.in
Merge made by the 'octopus' strategy.
  cmds-filesystem.c |  313 
++++++++++++++++++++++++++++++++++++++++++++---------
  cmds-scrub.c      |    8 +-
  man/btrfs.8.in    |  114 +++++++++++++++++++
  utils.c           |   70 ++++++++++--
  4 files changed, 440 insertions(+), 65 deletions(-)

Finally I tried with the email patches:

ghigo@venice:/tmp$ git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
Cloning into 'btrfs-progs'...
remote: Counting objects: 2692, done.
remote: Compressing objects: 100% (894/894), done.
remote: Total 2692 (delta 2015), reused 2380 (delta 1794)
Receiving objects: 100% (2692/2692), 818.83 KiB | 101 KiB/s, done.
Resolving deltas: 100% (2015/2015), done.
ghigo@venice:/tmp$ ls *.eml
[PATCH 1_2] Update btrfs filesystem df command.eml
[PATCH 1_3] Add support for different unit. - Goffredo Baroncelli 
<kreijack@gmail.com> - 2012-10-13 2127.eml
[PATCH 2_2] Update help page.eml
[PATCH 2_3] Deleted the byte prefix with pretty_sizes(). - Goffredo 
Baroncelli <kreijack@gmail.com> - 2012-10-13 2127.eml
[PATCH 3_3] Document the use of BTRFS_UNIT in man page. - Goffredo 
Baroncelli <kreijack@gmail.com> - 2012-10-13 2127.eml
ghigo@venice:/tmp$ cd btrfs-progs/
ghigo@venice:/tmp/btrfs-progs$ patch -p1 <../\[PATCH\ 1_2\]\ Update\ 
btrfs\ filesystem\ df\ command.eml
(Stripping trailing CRs from patch.)
patching file cmds-filesystem.c
ghigo@venice:/tmp/btrfs-progs$ patch -p1 <../\[PATCH\ 2_2\]\ Update\ 
help\ page.eml
(Stripping trailing CRs from patch.)
patching file man/btrfs.8.in
ghigo@venice:/tmp/btrfs-progs$ patch -p1 <../\[PATCH\ 1_3\]\ Add\ 
support\ for\ different\ unit.\ -\ Goffredo\ Baroncelli\ 
\<kreijack\@gmail.com\>\ -\ 2012-10-13\ 2127.eml
(Stripping trailing CRs from patch.)
patching file utils.c
ghigo@venice:/tmp/btrfs-progs$ patch -p1 <../\[PATCH\ 2_3\]\ Deleted\ 
the\ byte\ prefix\ with\ pretty_sizes\(\).\ -\ Goffredo\ Baroncelli\ 
\<kreijack\@gmail.com\>\ -\ 2012-10-13\ 2127.eml
(Stripping trailing CRs from patch.)
patching file cmds-filesystem.c
Hunk #1 succeeded at 411 (offset 209 lines).
(Stripping trailing CRs from patch.)
patching file cmds-scrub.c
ghigo@venice:/tmp/btrfs-progs$ patch -p1 <../\[PATCH\ 3_3\]\ Document\ 
the\ use\ of\ BTRFS_UNIT\ in\ man\ page.\ -\ Goffredo\ Baroncelli\ 
\<kreijack\@gmail.com\>\ -\ 2012-10-13\ 2127.eml
(Stripping trailing CRs from patch.)
patching file man/btrfs.8.in
Hunk #1 succeeded at 455 (offset 100 lines).

I have no idea on what happened...

BR
Goffredo


On 2012-10-15 13:58, Martin Steigerwald wrote:
> Am Samstag, 13. Oktober 2012 schrieb Goffredo Baroncelli:
>> Hi All,
>>
>> several people asked to update the units showed by the "btrfs" tool
>> form the SI ones (KB, MB, GB...) to the IEC ones (KiB, MiB...).
>>
>> The aim of this patch is to allow the user to choice which units
>> are showed. Depending by the BTRFS_UNIT environmental variable,
>> the following units are showed:
>>
>>      BTRFS_UNIT=SI the suffix is KB for 1000bytes, MB for 10^6 bytes...
>>      BTRFS_UNIT=IEC the suffix is KiB for 1024bytes, MiB for 1024 KiB ...
>>      BTRFS_UNIT=COMPACT the suffix is KB for 1024 bytes, MB for 1024 KiB;
>>                         no space between the number and the suffix.
>>
>> BR
>> G.Baroncelli
> What base does this build upon?
>
> I tried to apply upon your disk_free branch, but got:
>
> martin@merkaba:~/Linux/Dateisysteme/BTRFS/btrfs-progs-unstable>  patch -p1<  ../\[PATCH\]\[V1\]\[BTRFS-PROGS\]\ Replace\ the\ units\ from\ KB\ to\ KiB...mbox
> patching file utils.c
> Hunk #1 FAILED at 1085.
> 1 out of 1 hunk FAILED -- saving rejects to file utils.c.rej
> patching file cmds-filesystem.c
> Hunk #1 succeeded at 366 (offset 164 lines).
> patching file cmds-scrub.c
> patching file man/btrfs.8.in
> Hunk #1 succeeded at 424 (offset 69 lines).
>
> Thanks,

