Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s15.hotmail.com ([65.54.190.26]:56226 "EHLO
	BAY004-OMC1S15.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135AbaIWPZX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 11:25:23 -0400
Message-ID: <BAY172-W27ADBD4895716F53DE18EDB0B00@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: general thoughts and questions + general and RAID5/6 stability?
Date: Tue, 23 Sep 2014 10:25:23 -0500
In-Reply-To: <542187F3.7090603@gmail.com>
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com>
 <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at>
 <542162A8.2010700@gmail.com> <5421706F.6070301@xunil.at>
 <542177BF.2000808@gmail.com>
 <CAGwxe4i2gQXSPiBGXbUKWid3o1tmD_+YtbOj=GQ11vzGx8CuTw@mail.gmail.com>,<542187F3.7090603@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> If it is unknown, which of these options have been used at btrfs
>> creation time - is it possible to check the state of these options
>> afterwards on a mounted or unmounted filesystem?
>>
> I don't think there is a specific tool for doing this, but some of them
> do show up in dmesg, for example skinny-metadata shows up as a mention
> of the FS having skinny extents.
>
Devs,

It may be helpful to include the device in the kernel log for skinny extents.
Currently it shows up like the following which is a little ambiguous:

[    6.050134] BTRFS info (device sde3): disk space caching is enabled
[    6.056606] BTRFS: has skinny extents
<snipped>
[    7.740986] BTRFS info (device sde3): enabling auto defrag
[    7.747151] BTRFS info (device sde3): disk space caching is enabled
<snipped>
[    7.908906] BTRFS info (device sde2): enabling auto defrag
[    7.915031] BTRFS info (device sde2): disk space caching is enabled
[    8.071033] BTRFS info (device sde4): enabling auto defrag
[    8.076715] BTRFS info (device sde4): disk space caching is enabled
[    8.082187] BTRFS: has skinny extents
[    8.513502] BTRFS info (device sde5): enabling auto defrag
[    8.518887] BTRFS info (device sde5): disk space caching is enabled
[    8.524064] BTRFS: has skinny extents
[    9.634285] BTRFS info (device sdd6): enabling auto defrag
[    9.639308] BTRFS info (device sdd6): disk space caching is enabled
[    9.644338] BTRFS: has skinny extents

Thanks,
Kyle
 		 	   		  