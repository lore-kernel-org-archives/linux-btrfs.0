Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36445 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbLIV2b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 16:28:31 -0500
Received: by igcph11 with SMTP id ph11so128865331igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 13:28:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO_aGZvfkCYEtHsesRGQt9+L=LRwcgBx7oU-NB-doEvuvQ@mail.gmail.com>
References: <1449637341.20669.0.camel@love2code.net>
	<CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	<1449642609.20669.7.camel@love2code.net>
	<pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
	<1449682081.7150.0.camel@dhampton.net>
	<CAJCQCtSuEQRVsrLim9AD3di7Rxv2xA9FOd872pNXs-CRiFZpcw@mail.gmail.com>
	<CA+WRLO_aGZvfkCYEtHsesRGQt9+L=LRwcgBx7oU-NB-doEvuvQ@mail.gmail.com>
Date: Wed, 9 Dec 2015 14:28:30 -0700
Message-ID: <CAJCQCtR3OSZ5ncdz5-56yCRO-i0nsGtp3S6jzBPGmwFD3dN9Xg@mail.gmail.com>
Subject: Re: Missing half of available space (resend)
From: Chris Murphy <lists@colorremedies.com>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Chris Murphy <lists@colorremedies.com>,
        David Hampton <mailinglists@dhampton.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2015 at 12:56 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> I wouldn't blame Ubuntu too much, 14.10 went out of support months ago

OP reported 3.19.0-32-generic #37~14.04.1-Ubuntu. And 14.04 is LTS
supported until 2019. I think it should have something newer for both
kernel and progs, if it's going to offer btrfs as an install time
option. It's really easy to just have the LTS installer not offer
Btrfs, and not install btrfs-progs.



-- 
Chris Murphy
