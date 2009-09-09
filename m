From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a possible bug for the absence of memory barrier
Date: Thu, 10 Sep 2009 00:15:24 +0900
Message-ID: <2014bcab0909090815jf4929efib21cbf52b963e330@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I am reporting possible bugs caused
by the absence of memory barriers.

Please examine this issue and let me know your opinion.

In add_async_extent(), an async_extent object is allocated and initialized
and then links to &cow->extents.

However, since there is no memory barrier
between the initialization and the linking to the list,
these two operations are executed opposite order.
And the re-ordering might result race condition.

The similar issue is also in join_transaction().

Thank you

Sincerely

Shin Hong
