Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36055 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbCaWLo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 18:11:44 -0400
Received: by igbud6 with SMTP id ud6so32116231igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 15:11:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <HK2PR01MB0308B3759FC1AED779C219869AF40@HK2PR01MB0308.apcprd01.prod.exchangelabs.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<HK2PR01MB0308B3759FC1AED779C219869AF40@HK2PR01MB0308.apcprd01.prod.exchangelabs.com>
Date: Tue, 31 Mar 2015 16:11:43 -0600
Message-ID: <CAJCQCtQxEDA0Dje8HFRio8emAfrmTk-LZY5kOLmfuK9OEt7yCw@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 2:39 PM, Matt Grant
<matt.grant@foodstuffs-si.co.nz> wrote:
> Seen this before at home.
>
> You have to mount -o recovery off a 3.19 kernel to fix it...
>
> If you can get the SSD out, attach it to a desktop, as there will be no Install CDs using 3.19 yet.

Fedora 22 Workstation alpha has 4.0.0 (rc1 I think), and the current
TC6 beta has 4.0.0-rc4. It's possible to use the netinstall, which is
much smaller, and use boot param single or rescue to avoid the
installer launching.

And actually 3.19.2 is the stable kernel for Fedora 21, with 3.19.3
just pushed today (take mirrors a day or two to catch up), not 3.18.9
as I reported earlier.

-- 
Chris Murphy
