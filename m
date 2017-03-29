Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35672 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932143AbdC2JlT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 05:41:19 -0400
Received: by mail-qk0-f180.google.com with SMTP id r142so7829172qke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 02:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
References: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at> <22744.8089.282234.241186@tree.ty.sabi.co.uk>
 <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
From: Henk Slager <eye1tm@gmail.com>
Date: Wed, 29 Mar 2017 11:41:12 +0200
Message-ID: <CAPmG0jZoPFGjZ=HX=Cc0znLDDqATsvzz5Sqrt1Ft6Rz3+F+EQA@mail.gmail.com>
Subject: Re: send snapshot from snapshot incremental
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 12:01 AM, Jakob Schürz
<wertstoffe@nurfuerspam.de> wrote:
[...]
> There is Subvolume A on the send- and the receive-side.
> There is also Subvolume AA on the send-side from A.
> The parent-ID from send-AA is the ID from A.
> The received-ID from A on received-side A is the ID from A.
>
> To send the AA, i use the command
> btrfs send -p A AA|btrfs receive /path/to/receiveFS/
>
> The received-ID from AA on received-side A is the ID from AA.
>
>
> Now i take a snapshot from AA on the send-side -> Called AAA
Is AAA readonly?

> If i try to send AAA to the receiving FS with
> btrfs send -p AA AAA|btrfs receive /path/to/receiveFS/
> no parent snapshot is found.
Something else is wrong, as this simply should work. I think the
subvol AAA was created on the send side like this:
btrfs sub snap -r AA AAA

then the send -p should work.

> I should better take the -c Option.
>
> btrfs send -c AA AAA|btrfs receive /path/to/receiveFS/
>
> Am I right?
> (Sorry, cannot test it now, i do not have my external Drive here)
> I might remember, that this didn't work in the past...

I once had a working (test) situation with the -c option where send
and receive were on the same machine. But I use send|receive mostly
over long distance and/or mobile (metered) links, so the -c option is
not preferred by me, as besides the diffs in data also way more
metadata exchange is done. And normally, in order to be able do
meaningful incremental differences checking, you need a single chain
of transactions.

It looks like you want or have have been changing snapshots on the
receive side. If you want that changes played back to the send side,
you somehow need still at least 1 older read-only pair on send and
receive side to do the increment from, not only for -p option but also
for -c option. And after that, you likely need to do some merging on
the send side.

I think 2 redundancy principles needs are mixed, that's why the
confusion w.r.t. send|receive:
1- redundancy on content level, e.g. you make some changes to a
script, C-source or whatever document: read-only snapshots within the
same file-system on the send-side alone should be OK for that.
2- redundancy on device level, a HDD or SSD might fail, so you want
backup: RAID is meant for that.

Using btrfs send|receice for both 1 and 2 is fine and works well I can
say, as long you keep strict rules of what your master/working
file-system/subvolume is and always that pair of identical older
read-only snapshots existing on the send and receive side.
