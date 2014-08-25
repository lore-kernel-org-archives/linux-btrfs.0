Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54992 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaHYFJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 01:09:14 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so19534916pdj.29
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 22:09:14 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: fdmanana@gmail.com
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Do not free dirty extent buffer
References: <87mway82qp.fsf@elisp.net>
	<CAL3q7H61-uAP08uXNzsZfwKT8h1ZjRAR_GvD69wRKuRPpkbh9A@mail.gmail.com>
Date: Mon, 25 Aug 2014 14:09:07 +0900
In-Reply-To: <CAL3q7H61-uAP08uXNzsZfwKT8h1ZjRAR_GvD69wRKuRPpkbh9A@mail.gmail.com>
	(Filipe David Manana's message of "Sat, 23 Aug 2014 19:45:22 +0100")
Message-ID: <8761hh5f64.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Filipe David Manana <fdmanana@gmail.com> writes:

> On Thu, Aug 21, 2014 at 1:07 PM, Naohiro Aota <naota@elisp.net> wrote:
>> free_some_buffer() should not free dirty extent buffers. They should be
>> left for later commit.
>>
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>> ---
>>  extent_io.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/extent_io.c b/extent_io.c
>> index a127e54..8a668be 100644
>> --- a/extent_io.c
>> +++ b/extent_io.c
>> @@ -552,7 +552,7 @@ static int free_some_buffers(struct extent_io_tree *tree)
>>
>>         list_for_each_safe(node, next, &tree->lru) {
>>                 eb = list_entry(node, struct extent_buffer, lru);
>> -               if (eb->refs == 1) {
>> +               if (eb->refs == 1 && !(eb->flags && EXTENT_DIRTY)) {
>
> Hi,
>
> Did you meant bitwise and (&) and not logical and (&&) right?

Oops, you're right. Following is the new patch.

>From 0e1a49216d40b44909cdfacd5cd9a13aa796db41 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naota@elisp.net>
Date: Mon, 25 Aug 2014 14:03:59 +0900
Subject: [PATCH] btrfs-progs: Do not free dirty extent buffer

free_some_buffer() should not free dirty extent buffers. They are left
to be committed.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent_io.c b/extent_io.c
index a127e54..1df377d 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -552,7 +552,7 @@ static int free_some_buffers(struct extent_io_tree *tree)
 
 	list_for_each_safe(node, next, &tree->lru) {
 		eb = list_entry(node, struct extent_buffer, lru);
-		if (eb->refs == 1) {
+		if (eb->refs == 1 && !(eb->flags & EXTENT_DIRTY)) {
 			free_extent_buffer(eb);
 			if (tree->cache_size < cache_hard_max)
 				break;
-- 
2.0.4

