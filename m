Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37410 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbcAHOkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 09:40:31 -0500
Received: by mail-ig0-f181.google.com with SMTP id h5so35693654igh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jan 2016 06:40:31 -0800 (PST)
Subject: Re: send/receive for encrypted backup purposes
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
References: <1827847.pVfOzZHEoP@merkaba>
 <1452261646.6727.12.camel@scientia.net> <4248922.XAnqWXRFKA@vajra>
 <1452262041.6727.15.camel@scientia.net>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <568FCA55.90000@gmail.com>
Date: Fri, 8 Jan 2016 09:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <1452262041.6727.15.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-08 09:07, Christoph Anton Mitterer wrote:
> On Fri, 2016-01-08 at 15:02 +0100, Swâmi Petaramesh wrote:
>> Le vendredi 8 janvier 2016, 15:00:46 Christoph Anton Mitterer a écrit
>> :
>>> Shouldn't any crypto that can read from stdin and write to stdout
>>> do
>>> that?
>>> E.g. simply ssh.
>>>
>>> hostA$ btrfs send foo | ssh hostB btrfs receive bar
>>
>> It works, I do this on a regular basis…
>
> One should perhaps only ask some SSH experts, whether their crypto is
> actually safe for such use case.
> I mean depending on what kind of data is send (e.g. often repeating
> patterns and so on) some crypto schemas may be more pron to statistical
> attacks than other.
>
> But I wouldn't see much problems... ssh has rather problems with
> statistical attacks when measuring keystroke times...
>
The send data stream is (from what I can tell) about as structured as 
HTML over HTTP (although with binary data, not text), so it's likely 
similar security to using HTTPS (SSH uses essentially the same 
techniques as TLS, it's just part of the protocol as opposed to an 
intermediary layer).  That said, if you're using forced compression on 
the source FS, that may weaken things a bit.

One thing I would say in this case is to avoid using SSH compression. 
If you're on a local link, it's wasteful for bulk transfers; and even 
with non-local connections, it's not usually beneficial unless you pay 
per-unit transferred (like happens on a lot of cell networks).
