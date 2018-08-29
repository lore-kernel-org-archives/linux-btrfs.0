Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37973 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbeH2QjC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 12:39:02 -0400
Subject: Re: btrfs fi du unreliable?
To: Jorge Bastos <jorge.mrbastos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAHzMYBT22xie_4Tjp+Zn6w7DG0sDAdkRRDrgesUvJ60j0TrmnA@mail.gmail.com>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <7660605b-d456-308a-7040-720ff31f7181@georgianit.com>
Date: Wed, 29 Aug 2018 08:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAHzMYBT22xie_4Tjp+Zn6w7DG0sDAdkRRDrgesUvJ60j0TrmnA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------467B25A7649C5BECE9CA9EF1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------467B25A7649C5BECE9CA9EF1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-08-29 08:00 AM, Jorge Bastos wrote:

> 
> Look for example at snapshots from July 21st and 22nd, total used
> space went from 199 to 277GiB, this is mostly from new added files, as
> I confirmed from browsing those snapshots, there were no changes on
> the 23rd, and a lot of files were deleted before the 24th, so should't
> there be about 80GiB of exclusive content for the 22nd, or am I
> misunderstanding how this is reported? ? Those were new files only,
> never existed on previous snapshots, If I delete both snapshots from
> the 22nd and the 23rd I expect to get about 80GiB freed space.

Exclusive means... exclusive... to that 1 snapshop/subvolume.  If the
data also exists on the 23'rd snapshot, it's not exclusive.

If you wanted to report how much data is exclusive to a group of
snapshots, (say, July 22 *and* 23rd). you would have to make them
members of a parent qgroup, then, you could see the exclusive value of
the whole group.


--------------467B25A7649C5BECE9CA9EF1
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


--------------467B25A7649C5BECE9CA9EF1--
