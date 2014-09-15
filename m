Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56704 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaIOR5w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 13:57:52 -0400
Date: Mon, 15 Sep 2014 10:57:47 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: btrfs differential receive has become excrutiatingly slow on one
 machine
Message-ID: <20140915175747.GZ8530@merlins.org>
References: <20140908015124.GA21441@merlins.org>
 <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
 <20140915001836.GU8530@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140915001836.GU8530@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 14, 2014 at 05:18:36PM -0700, Marc MERLIN wrote:
> I'm still waiting for the next incremental backup to run.
> Once it's done, I'll try to run a smaller one under strace so I don't
> have a ridiculously long log to give you.
> 
> Is there a reasonable way to know if btrfs receive is indeed hanging on
> kernel code, and whether it's on receive code or on code that tries to
> writes the files on the filesystem in the new snapshot?

Ok, so my incremental sync of /var which I had _just_ fully copied over,
took over 12H and then died with

ABORT: btrfs send /mnt/btrfs_pool1/var_ggm_daily_ro.20140913_14:50:24 var_ggm_daily_ro.20140914_19:16:48 | ssh gargamel.merlins.org btrfs receive /mnt/btrfs_pool2/backup/debian64/legolas/ failed
Write failed: Broken pipe

I'm not sure that my ssh connection went down because it was at home on
reliable wireless and I had other connections that were fine during that
time, but you never know.

Unfortunately, due to my stupidity, the strace logging failed, but it looks 
like I got about 12H worth of the following below. Interestingly that directory
is nocow (VM images).
Does btrfs send get unhappy with NOCOW?

Thanks,
Marc

read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 49212) = 15511 <0.000023>
read(0, "\336\350A\340\2@\377p\20\377u\360\3\36T\245\241\25\307\2033\314E`\20,f\20\25C$4"..., 33701) = 32768 <0.117252>
read(0, "\210:\214:\220:\224:\0\230:\234:\240:\244:\0\250:\254:\260:\264:\0\270:\304:\310"..., 933) = 933 <0.369642>
pwrite(5, "`\273\0}\300\271\f\0\0\0003\0\300\363\253\213\3163\300\211\0E\350\211U\274\213\331\213\0E\274"..., 49152, 32698048512) = 49152 <0.000086>
read(0, "<\260\0\0\17\0\224\22\261\v", 10) = 10 <0.000013>
read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 45116) = 31825 <0.000024>
read(0, "\325\260\3 \270\3T\270\3\340y\7\201\1\\\350\16\262\3\241\0\261\3\207\260\0038\271\0\354Z\347"..., 13291) = 13291 <0.228846>
pwrite(5, "\363\273\0\0\0\0\350\30(\353\377\0\213F\4\211E\340\213N@\0209\t\350\10\227\0x\330\0\213"..., 45056, 32698114048) = 45056 <0.000060>
read(0, "<\260\0\0\17\0(-\275\365", 10) = 10 <0.000044>
read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 45116) = 19467 <0.000021>
read(0, "\3\341\23P\25\241\3\360\240\3\211b\10\205\311u\0>\213G\10\203x(\0\4t5\0\1\213@"..., 25649) = 25649 <0.176543>
pwrite(5, "\226\272\10\377j\1\1\20\213\323\213\316\0\350\310N\352\377\211GH\0\351\37\1\0\0\213N(\0009"..., 45056, 32698179584) = 45056 <0.000071>
read(0, "<`\0\0\17\0\tmn,", 10)         = 10 <0.000043>
read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 24636) = 7109 <0.000019>
read(0, "\377\307A\10 \243\377\240\7\300m\352^\200\2\2140\3P0\2\204\1\245\3\1\320\31\314\314D\30"..., 17527) = 17527 <0.113324>
pwrite(5, "P\272\0\n\351\377\213G\4\213@\20 \211E\360\2\200\10\211E\0\3543\366\203}\360\0~H\\"..., 24576, 32698245120) = 24576 <0.000055>
read(0, "<\200\0\0\17\0\346\vV\270", 10) = 10 <0.000030>
read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 32828) = 15231 <0.000017>
read(0, "\350\24\202b\243(\206@\n\213E\350H\377p\10\301\26\213\310\240\26'\10\261\377\377\5f\213~T"..., 17597) = 17597 <0.165656>
pwrite(5, "\200\320u\327\205\366~u\251%D\v\372\240+\310\213\201#\36\350\320\213E\350\213!%\360`\234\300"..., 32768, 32699318272) = 32768 <0.000057>
read(0, "<@\0\0\17\0\221\256ob", 10)    = 10 <0.000015>
read(0, "\17\0(\0local/nobck/VirtualBox VMs/W"..., 16444) = 15161 <0.000015>
read(0, "\210V<4a\273\10\23\372\240\227o\20\332\267\30S\375\2628oy\271\370yj\211ryr\335\177"..., 1283) = 1283 <0.190593>
pwrite(5, "\342\377\303\320vr\21\364zs|N\302\36\262\20N\203\224\212R\315\222S)\231E\255\344\265X\211"..., 16384, 32699351040) = 16384 <0.000050>
read(0, "<\300\0\0\17\0:\205\337\336", 10) = 10 <0.000015>



-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
