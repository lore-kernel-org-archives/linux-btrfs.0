Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44897 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2FYWqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 18:46:11 -0400
Received: by obbuo13 with SMTP id uo13so7092101obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 15:46:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE8E829.6060305@zytor.com>
References: <4FE1F9E4.5090301@zytor.com>
	<CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com>
	<20120621005048.GA19507@shiny>
	<670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com>
	<20120625152142.GD17638@shiny>
	<4FE8A3D9.3060400@zytor.com>
	<CA+WRLO87LvTrRJRMNwYQ3SwmZWF7WzO_FDi1=jqt1kwX=YSnWQ@mail.gmail.com>
	<4FE8E829.6060305@zytor.com>
Date: Tue, 26 Jun 2012 08:46:10 +1000
Message-ID: <CA+WRLO_zTTuqFHctEOMEY1pgH0R0UUtMuiaVD9Tnqxw05AdXaw@mail.gmail.com>
Subject: Re: Feature request: true RAID-1 mode
From: Gareth Pye <gareth@cerberos.id.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 8:37 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> They do?  E.g. mdadm doesn't make them...

Hrm, you are right. It is something I always confirm is happening
though. Without a M=N mode there would need to be two balances as the
first balance would be doing it wrong :(


-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
