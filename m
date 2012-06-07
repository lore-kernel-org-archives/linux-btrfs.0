Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:53977 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2FGOMY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 10:12:24 -0400
Received: from mx.meyering.net (unknown [88.168.87.75])
	by smtp5-g21.free.fr (Postfix) with ESMTP id E0705D4812E
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2012 16:12:17 +0200 (CEST)
From: Jim Meyering <jim@meyering.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 4/4] mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg
In-Reply-To: <20120606193558.GT15986@carfax.org.uk> (Hugo Mills's message of
	"Wed, 6 Jun 2012 20:35:59 +0100")
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
	<1334950046-24147-5-git-send-email-jim@meyering.net>
	<20120606193558.GT15986@carfax.org.uk>
Date: Thu, 07 Jun 2012 16:12:16 +0200
Message-ID: <871ulrw6rj.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:
>> diff --git a/mkfs.c b/mkfs.c
>> index 03239fb..4aff2fd 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -63,7 +63,7 @@ static u64 parse_size(char *s)
>>
>>  	s = strdup(s);
>>
>> -	if (!isdigit(s[len - 1])) {
>> +	if (len && !isdigit(s[len - 1])) {
>
>    I think I'd prefer that len is a size_t, not an int here. (Or that
> len is tested to be >0).
>
>>  		c = tolower(s[len - 1]);
>>  		switch (c) {
>>  		case 'g':

IMHO, there is no contest.  The correct type is size_t.
If you'd like to include that type change along with the bug fix,
here's the patch:

(However, note that even a quick git grep 'int.*strlen' shows five
more instances of this technically-subject-to-overflow use of "int",
so it might be better to fix them all at once -- auditing to ensure
that no use requires the signed type, of course.

    btrfs-list.c:           int add_len = strlen(found->path);
    btrfs.c:        int len = strlen(argv0_buf);
    cmds-filesystem.c:      int len = strlen(s);
    mkfs.c: int len = strlen(input);
    utils.c:       int len = strlen(input);

)

>From 666892466e85c228f897104e5bced2c99d798302 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Tue, 17 Apr 2012 14:56:28 +0200
Subject: [PATCH] mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg

* mkfs.c (parse_size): ./mkfs.btrfs -A '' would read and possibly
write the byte before beginning of strdup'd heap buffer.  All other
size-accepting options were similarly affected.

Reviewed-by: Josef Bacik <josef@redhat.com>
---
 mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 03239fb..017e317 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -56,14 +56,14 @@ struct directory_name_entry {

 static u64 parse_size(char *s)
 {
-	int len = strlen(s);
+	size_t len = strlen(s);
 	char c;
 	u64 mult = 1;
 	u64 ret;

 	s = strdup(s);

-	if (!isdigit(s[len - 1])) {
+	if (len && !isdigit(s[len - 1])) {
 		c = tolower(s[len - 1]);
 		switch (c) {
 		case 'g':
--
1.7.11.rc1
