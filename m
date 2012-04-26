From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: Interpreting Output of "btrfs fi show"
Date: 26 Apr 2012 15:59:00 +0200
Message-ID: <C7$hz9fuCXB@helmut.hullen.de>
References: <20120426115326.GO20982@twin.jikos.cz>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120426115326.GO20982@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, David,

Du meintest am 26.04.12:

>> I now use to delete about the first 10 MByte of the target disk via
>> "dd if=/dev/zero"

> FYI, the minimal amount of data you need to rewrite is 4k:

> dd if=/dev/zero of=/dev/ice bs=1k count=4 seek=64

Thank you - I'll try to remember the next time I need this command!

Viele Gruesse!
Helmut
