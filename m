Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s12.hotmail.com ([65.55.116.23]:60589 "EHLO
	BLU004-OMC1S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbbJ2StI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 14:49:08 -0400
Message-ID: <BLU436-SMTP16089042EF8E0078CC4A5A8A9200@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
	<562E37F4.9080602@oracle.com>
	<CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
	<CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
	<CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
	<CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
	<CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
	<562F638B.1040701@gmail.com>
	<BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
	<562F7C7B.6060408@gmail.com>
	<CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
	<CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
	<CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
	<CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
	<562F97B5.8000108@gmail.com>
	<CA+9GZUhKmH9x_D6r=P8p=E4H38t+jcUQd1bFeVeE_uj1GyTA8A@mail.gmail.com>
	<56322679.8050001@gmail.com>
	<CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
Date: Thu, 29 Oct 2015 19:49:03 +0100
Subject: Re: Bad fs performance, IO freezes
From: Henk Slager <hslager@hotmail.com>
To: "cheater00 ." <cheater00@gmail.com>
CC: Austin S Hemmelgarn <ahferroin7@gmail.com>, Liu Bo <bo.li.liu@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The graph uploaded shows 'Up speed' and 'Down speed', I just assumed
that this is network speed and not disk I/O. Is this correct
assumption? If so, how does the traffic to/from the /dev/sdX look like
(e.g. iostat or ksysguard) ?

W.r.t. USB: I had quite some trouble with NEC/Renesas USB3 host
controller 2 years back. I got it working once under windows7 after
quite some drivers version trials. Under linux it is listed, but I
don't use is anymore; On the same PC under windows7 it doesn't work
anymore. For btrfs on WD elements and Sandisk Extreme on ASUS H87M-Pro
with kernels 3.x kernels (64-bit) I got similar freezes/perfomance
issues as mentioned here. The same fs configurations and tests on sata
cabled (2TB HDD) did not show these hickups. I have now mostly ext4 on
those USB connected disk, so with 4.3-rcX kernels I cant tell more.

There might be many configuration issues if a drive is connected via
removable USB, like writeback-caching etc. I have not looked into all
possible issues any further.
A month ago I got quite some random I/O and timeout errors on a 4TB
raw dd_rescue copy action (1 HDD in USB3 bay), kernel 4.1.6. Then
hooked-up all 3 disks, including rootfs, to another motherboard via
sata and not a single error. On the other hand, I have also a 2TB disk
connected via USB2 formatted btrfs and online 24/7 for over a year and
it works fine.

So I would (temporary) connect this WB 6TB via sata and use some
latest 64-bit liveCD/DVD linux distro and see how the disktraffic is
for some file copy or defrag action. And then, step by step go back to
your original configuration. Also make sure the disk is not filled
much more than 95%, as that could easily lead to the situation that
your latest active files will easily be very scattered, so not
beneficial for fs performance.
