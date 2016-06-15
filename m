Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:11670 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbcFOB4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 21:56:39 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id DF688AC00FE
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 10:56:34 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: doc: correct the destination of
 btrfs-receive
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
 <20160614085133.GE6205@twin.jikos.cz> <20160614091608.GC5437@carfax.org.uk>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <9a4c1521-f1eb-8eaf-59c8-f2e0cb897ed9@jp.fujitsu.com>
Date: Wed, 15 Jun 2016 10:55:45 +0900
MIME-Version: 1.0
In-Reply-To: <20160614091608.GC5437@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/14 18:16, Hugo Mills wrote:
> On Tue, Jun 14, 2016 at 10:51:33AM +0200, David Sterba wrote:
>> On Tue, Jun 14, 2016 at 02:50:19PM +0900, Satoru Takeuchi wrote:
>>> We can set not only btrfs mount point but also any path belong to
>>> btrfs mount point as btrfs-receive's destination.
>>>
>>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> The patches from you have a consistent whitespace damage, I've fixed
>> the btrfs-crc but now that I see it again I suspect some error on your
>> side.

The problem is on my side. I'm sorry.

>>
>>> @@ -7,14 +7,14 @@ btrfs-receive - receive subvolumes from send stream
>>>
>>>   SYNOPSIS
>>>   --------
>>> -*btrfs receive* [options] <mount>
>>> +*btrfs receive* [options] <path>
>>>
>>>   DESCRIPTION
>>>   -----------
>>>
>>>   Receive a stream of changes and replicate one or more subvolumes that were
>>>   previously used with *btrfs send* The received subvolumes are stored to
>>> -'mount'.
>>> +'path'.
>>>
>>>   *btrfs receive* will fail int the following cases:
>>>
>>> @@ -37,7 +37,7 @@ by default, btrfs receive uses standard input to receive the stream,
>>>   use this option to read from a file instead
>>>
>>>   -C|--chroot::
>>> -confine the process to 'mount' using `chroot`(1)
>>> +confine the process to 'path' using `chroot`(1)
>>>
>>>   -e::
>>>   terminate after receiving an 'end cmd' marker in the stream.
>>
>> ie. all the context lines start with two spaces instead of one. I'll
>> apply this patch manually but please have a look.
> 
>    Looking at this, I suspect it's a consequence of sending it as
> "Content-Type: format=flowed; delsp=yes". I'm not sure which of those
> two options is the culprit. When I look at the message in my client
> (mutt), it looks absolutely fine. When I pipe it to hexdump, the
> double-spacing is apparent.

You're right. These are added to charset="iso-2022-jp" plain text
mail since thunderbird 45.

I disabled the setting that appends the above mentioned options.
So, probably the following sample patch doesn't have strange spaces.

===================================
We can set not only btrfs mount points but also any paths belong to
btrfs mount point as btrfs-receive's destination.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/btrfs-receive.asciidoc | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index fbbded2..e246603 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -7,14 +7,14 @@ btrfs-receive - receive subvolumes from send stream

 SYNOPSIS
 --------
-*btrfs receive* [options] <mount>
+*btrfs receive* [options] <path>

 DESCRIPTION
 -----------

 Receive a stream of changes and replicate one or more subvolumes that were
 previously used with *btrfs send* The received subvolumes are stored to
-'mount'.
+'path'.

 *btrfs receive* will fail int the following cases:

@@ -37,7 +37,7 @@ by default, btrfs receive uses standard input to receive the stream,
 use this option to read from a file instead

 -C|--chroot::
-confine the process to 'mount' using `chroot`(1)
+confine the process to 'path' using `chroot`(1)

 -e::
 terminate after receiving an 'end cmd' marker in the stream.
-- 
2.5.5
===================================

Thanks,
Satoru

> 
>    Hugo.
> 
