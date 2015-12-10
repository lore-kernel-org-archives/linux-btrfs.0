Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vwp7940.webpack.hosteurope.de ([178.77.87.119]:48306 "EHLO
	vwp7940.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbbLJM5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 07:57:35 -0500
Message-ID: <566976BA.2020008@anonym.com>
Date: Thu, 10 Dec 2015 13:57:30 +0100
From: "S.J." <sorry@anonym.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: attacking btrfs filesystems via UUID collisions?
References: <20151204120529.37E47D5A28@emkei.cz> <20151204130758.GR8775@carfax.org.uk> <1449286104.18841.14.camel@scientia.net> <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net> <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com> <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com> <56696B53.7070905@gmail.com> <20151210124129.GI2376@carfax.org.uk>
In-Reply-To: <20151210124129.GI2376@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 10.12.2015 13:41, schrieb Hugo Mills:
> On Thu, Dec 10, 2015 at 07:08:51AM -0500, Austin S Hemmelgarn wrote:
>> On 2015-12-09 16:48, S.J. wrote:
>>>> 1. better practices, we really need to tell users, and documentation
>>>> writers, that using dd (or variant) to copy Btrfs volumes has a
>>>> consequence and should not be used to make copies.
>>>> 2. Btrfs needs a better way to make a copy of a volume when there are
>>>> snapshots (including even rw snapshots); e.g. permit send/receive to
>>>> work on rw snapshots if the fs is ro mounted; e.g. a way to do
>>>> "recursive" send/receive.
>>>> 3. Some way to fail gracefully, when there's ambiguity that cannot be
>>>> resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
>>>> then there's simply no way to resolve the ambiguity automatically, and
>>>> the volume should just refuse to rw mount until the user resolves the
>>>> ambiguity. I think it's OK to fallback to ro mount (maybe) by default
>>>> in such a case rather than totally fail to mount.
>>> About 3:
>>> RO fallback for the second device/partitions is not good.
>>> It won't stop confusing the two partitions, and even if both are RO,
>>> thinking it's ok to read and then reading the wrong data is bad.
>>>
>>> About 1 and 2 ... if 3 gets fulfilled, why?
>>> DD itself is not a problem "if" the UUID is changed after it
>>> (which is a command as simple as dd), and if someone doesn't
>>> know that, he/she will notice when mount refuses to work
>>> because UUID duplicate.
>> Unless things have changed significantly, changing the UUID on a BTRFS
>> image is not anywhere near as simple as copying it with dd.  The UUID
>> gets used internally somehow, and changing it would require rewriting
>> _all_ the metadata blocks.
>     Indeed, but there is now a tool to do that. :) (btrfstune -u or -U)
>
>     Hugo.
>
Yes, I meant that :)
I'm not saying that the tool is internally as simple as a
"dumb" dd block copy , but calling it certainly is.

