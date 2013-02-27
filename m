Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56650 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3B0VUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 16:20:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAEzrpqeQTVwSYd_0NpjnfMJKiLPeL-tC2tGPAh6ov2ViBndXUg@mail.gmail.com>
References: <20130227052247.GA20213@redhat.com>
	<20130227132736.GH19641@localhost.localdomain>
	<CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
	<20130227182617.GI19641@localhost.localdomain>
	<CAFDW0jJ2yHftRW5Kp8sc+uxNC3oS4AZKqG0Szz2rUyxeeA0+2Q@mail.gmail.com>
	<CAEzrpqeQTVwSYd_0NpjnfMJKiLPeL-tC2tGPAh6ov2ViBndXUg@mail.gmail.com>
Date: Wed, 27 Feb 2013 22:20:54 +0100
Message-ID: <CAFDW0j+=ULTneaMsZKAQW1mOQqMA5U11jAbqPzebKWDJQeJf5A@mail.gmail.com>
Subject: Re: btrfs crash when low on memory.
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Josef Bacik <jbacik@fusionio.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If we're corrupting on abort that is a bug too that needs to be fixed
> too.  I've banged on the abort stuff a lot recently when trying to
> make it not panic the box and it appears to work fine.  Obviously that
> kind of stuff needs to be tested as well, but so far I haven't seen
> abort corrupt the file system.  Thanks,

thank you for the info Josef.
i will report a bug next time i hit such a case then.

Ahmet
