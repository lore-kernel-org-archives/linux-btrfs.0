Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41930 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3CVGlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 02:41:07 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so4504815ieb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 23:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48C0CCB4-5381-4569-B777-472EC2EF1725@profihost.ag>
References: <514ABEB8.3090104@profihost.ag>
	<20130321180020.30044.84729@localhost.localdomain>
	<967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag>
	<20130321190249.30044.79438@localhost.localdomain>
	<514B62A4.1030201@profihost.ag>
	<20130322121356.237e57e8@natsu>
	<CAE5mzvizzxotHP2OikoBZ1+OuHm_WBgMVHuWnm+Unr+DfAfXxQ@mail.gmail.com>
	<48C0CCB4-5381-4569-B777-472EC2EF1725@profihost.ag>
Date: Fri, 22 Mar 2013 00:41:06 -0600
Message-ID: <CAE5mzvh4mdVLagEFynZOqoM_7_3Yrojd2WLowWGw-AqZPhH1XQ@mail.gmail.com>
Subject: Re: No space left on device (28)
From: cwillu <cwillu@cwillu.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Roman Mamedov <rm@romanrm.ru>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 12:39 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> Already tried with value 5 did not help ;-( and it also happens with plain cp copying a 15gb file and aborts at about 80%

You tried -musage=5?  Your original email said -dusage=5.
