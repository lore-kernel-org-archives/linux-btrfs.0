From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: Re: [PATCH] Function btree_get_extent: Incorrect if-else if statement
Date: Mon, 6 Sep 2010 22:15:02 +0800
Message-ID: <AANLkTimXO7td7xxD1_MVACjbKomE0VBLLV7A1U0z00eR@mail.gmail.com>
References: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?UTF-8?Q?Andr=C3=A9_Nogueira?= <andre.neo.net@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is not correct.

2010/8/9 Andr=C3=A9 Nogueira <andre.neo.net@gmail.com>:
> The btree_get_extent function (in file disk-io.c) calls the
> add_extent_mapping (in file extent_map.c). The add_extent_mapping
> function can return two values: 0 or -EEXIST.

It might return some other error values besides -EEXIST, the 'else if
(ret)' branch
is just against them.
Namely, we should do some thing special when EEXIST, and do another thi=
ngs
for all other errors.

Regards,
Zhu Yanhai
