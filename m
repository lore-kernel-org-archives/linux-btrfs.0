Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:33934 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbdKMICl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 03:02:41 -0500
Subject: Re: btrfs-image hash collision option, super slow
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
 <20171112004230.GJ27985@carfax.org.uk>
 <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
 <4bc2caf5-6f4c-4012-2bab-4daaa766d202@siedziba.pl>
 <CAJCQCtSG+pVM95G-vwnDX=aqGK6_LJ_D0H=5W_VYMsrdH_=XJw@mail.gmail.com>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <55071ffd-e80e-4b0f-15a3-2381b928d0f8@siedziba.pl>
Date: Mon, 13 Nov 2017 09:02:37 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSG+pVM95G-vwnDX=aqGK6_LJ_D0H=5W_VYMsrdH_=XJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 13.11.2017 o 04:42, Chris Murphy pisze:
> Strange. I was using 4.3.3 and it had been running for over 9 hours at
> the time I finally cancelled it.

If you're compiling from source, the usual advice would be to "make clean" and make sure you're using the correct executable.

If your fs is very large then caching may be a problem. With the brute force method it was a good idea to cache the results. With the "reverse crc" method caching is not very useful. It's only marginally faster on my root fs, and on larger filesystems searching the cache will be slower than finding collisions. You can remove the code and see if it makes any difference:

diff --git a/image/main.c b/image/main.c
index 4cffbdba..f77b1504 100644
--- a/image/main.c
+++ b/image/main.c
@@ -500,19 +500,9 @@ static char *find_collision(struct metadump_struct *md, char *name,
                            u32 name_len)
 {
        struct name *val;
-       struct rb_node *entry;
-       struct name tmp;
        int found;
        int i;
 
-       tmp.val = name;
-       tmp.len = name_len;
-       entry = tree_search(&md->name_tree, &tmp.n, name_cmp, 0);
-       if (entry) {
-               val = rb_entry(entry, struct name, n);
-               free(name);
-               return val->sub;
-       }
 
        val = malloc(sizeof(struct name));
        if (!val) {
@@ -548,7 +538,6 @@ static char *find_collision(struct metadump_struct *md, char *name,
                }
        }
 
-       tree_insert(&md->name_tree, &val->n, name_cmp);
        return val->sub;
 }

>
>> Unfortunately there are no CRC32 collisions for any file name having 4 or less characters when you have to keep the same file name length, and there may be no collisions for longer file names when you limit the result to ASCII only.
> Gotcha.

Yeah, it also means for short file names an attacker can easily find the real name by finding all collisions and filtering out obviously nonsensical names, so it's more of an obfuscation than sanitization :/

