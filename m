Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43706 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaAPUaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 15:30:30 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so3133613pbc.34
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 12:30:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140116121906.GP10639@merlins.org>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
	<A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com>
	<CAKcLGm-Km3svoJ4oPGUdv8Wh__qsNAjujVmhF=46dwQP4HaeNw@mail.gmail.com>
	<5A3CA53B-B359-4DE0-A31B-49F98A1EBF7C@colorremedies.com>
	<20140116121906.GP10639@merlins.org>
Date: Thu, 16 Jan 2014 21:30:29 +0100
Message-ID: <CAFP7zVsCBq6=+3jGFA-3BAAXUXeH1A72xM=GPG=88oZZdV5dPg@mail.gmail.com>
Subject: Re: btrfsck failes
From: Holger Brandsmeier <brandsmeier@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Content-Type: multipart/mixed; boundary=047d7b33d628e8b17104f01c4b2d
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--047d7b33d628e8b17104f01c4b2d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I agree to Marc, I created a small patch to `cmds-check.c` (see
attachments). It displays a warning message for 10 seconds if the
repair option is enabled. If you think this is a good idea, can
someone apply this patch?

I am going to roll in my backup soon. Is there anything more that I
should give you as a feedback? I did file one bug:

https://bugzilla.kernel.org/show_bug.cgi?id=3D68771

On Thu, Jan 16, 2014 at 1:19 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Wed, Jan 15, 2014 at 10:16:13AM -0700, Chris Murphy wrote:
>>
>> On Jan 15, 2014, at 9:15 AM, Mitch Harder <mitch.harder@sabayonlinux.org=
> wrote:
>>
>> > On Mon, Jan 13, 2014 at 6:37 PM, Chris Murphy <lists@colorremedies.com=
> wrote:
>> >>
>> >> On Jan 13, 2014, at 3:58 PM, Holger Brandsmeier <brandsmeier@gmail.co=
m> wrote:
>> >>>
>> >>> Currently btrfsck failes to repair my partition, I get the output:
>> >>>
>> >>> [root@ho-think bholger]# btrfsck --repair /dev/sda5
>> >>
>> >> This is almost the last resort and you probably should be posting to =
the list before using repair.
>> >>
>> >>
>> >
>> > This is like saying:
>> >
>> > "Yes, btrfs does now have a working btrfsck, but only for the select
>> > few who manage to get through on the mailing list for support."
>> >
>> > I'd like to think that's not the case.
>>
>> Yet that's exactly what the wiki suggests: "If you have a broken filesys=
tem, it is probably better to use btrfsck with advice from one of the btrfs=
 developers, just in case something goes wrong. (But even if it does go bad=
ly wrong, you've still got your backups, right?)"
>>
>> I think it's understandably annoying that the repair tool could make thi=
ngs worse rather than fail gracefully, because restoring from backups is te=
dious. But the only way it gets better is if people break both the file sys=
tem and the repair tools in ways the devs can't possibly predict.
>
> I hate to be a broken record :) but telling people they should read/have
> read a wiki when they are in the middle of fixing a filesystem is not
> the right way to go.
> On my laptop while travelling, it would even be my only way to boot and
> maybe I can't get to the internet until my FS is fixed (maybe, maybe
> not, but you get the idea).
>
> My main point again (sorry) is still that the man page and usage info of =
btrfsck
> should really warn users "this is likely NOT what you want to run,
> please read the manpage, or HOWTO in /usr/share/doc/ with details about
> mount recovery and other things to try first".
>
> Think of it as a good thing, it means more btrfs users, and they are
> used to working a certain way. It's for btrfs to adapt to how they're
> used to working when possible.
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.=
S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet c=
ooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/7=
63BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--047d7b33d628e8b17104f01c4b2d
Content-Type: text/x-patch; charset=US-ASCII; name="cmds-check.patch"
Content-Disposition: attachment; filename="cmds-check.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqih0pks0

LS0tIGNtZHMtY2hlY2suYworKysgY21kcy1jaGVjay5jCkBAIC02NDI3LDYgKzY0MjcsMTUgQEAg
aW50IGNtZF9jaGVjayhpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAgICAgICAgaWYgKGFyZ2MgIT0g
MSkKICAgICAgICAgICAgICAgIHVzYWdlKGNtZF9jaGVja191c2FnZSk7CiAKKyAgICAgICBpZiAo
cmVwYWlyICE9IDApIHsKKyAgICAgICAgICAgICAgIHByaW50ZigiXG5XQVJOSU5HOiB5b3UgZW5h
YmxlZCByZXBhaXIgbW9kZSwgdGhpcyBvcHRpb24gY291bGQgbWFrZSAiCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIm1hdHRlcnMgd29yc2UgZm9yIHlvdXIgZGF0YS4gSXQgaXMgcmVj
b21tZW5kZWQgdG8gY2hlY2sgd2l0aCB0aGUgIgorICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICJsaW51eC1idHJmc0B2Z2VyLmtlcm5lbC5vcmcgbWFpbGluZyBsaXN0IGJlZm9yZSB5b3Ug
cHJvY2VlZC5cbiIpOworICAgICAgICAgICAgICAgcHJpbnRmKCJTbGVlcGluZyBmb3IgMTAgc2Vj
b25kcyB0byBnaXZlIHlvdSB0aW1lIHRvIGNvbnNpZGVyLi4uIgorICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICIgaGl0IGN0cmwrYyBpZiB5b3UgY2hhbmdlZCB5b3VyIG1pbmQuXG4iKTsK
KyAgICAgICAgICAgICAgIHNsZWVwKDEwKTsKKyAgICAgICB9CisKICAgICAgICByYWRpeF90cmVl
X2luaXQoKTsKICAgICAgICBjYWNoZV90cmVlX2luaXQoJnJvb3RfY2FjaGUpOwoK
--047d7b33d628e8b17104f01c4b2d--
