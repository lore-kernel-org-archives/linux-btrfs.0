Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38483 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389476AbeHAQT0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 12:19:26 -0400
Subject: Re: BTRFS and databases
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <8b5d3277-1afc-9b10-2960-f9fd4396e2e1@georgianit.com>
Date: Wed, 1 Aug 2018 10:33:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------207838C9A1F26F26F85859EA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------207838C9A1F26F26F85859EA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2018-07-31 11:45 PM, MegaBrutal wrote:

> I know that with nodatacow, I take away most of the benefits of BTRFS
> (those are actually hurting database performance – the exact CoW
> nature that is elsewhere a blessing, with databases it's a drawback).
> But are there any advantages of still sticking to BTRFS for a database
> albeit CoW is disabled, or should I just return to the old and
> reliable ext4 for those applications?
> 

Be very careful about nodatacow and btrfs 'raid'.  BTRFS has no data
synching mechanism for raid, so if your mirrors end up different
somehow, your Array is going to be inconsistent.

--------------207838C9A1F26F26F85859EA
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------207838C9A1F26F26F85859EA--
