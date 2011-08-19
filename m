From: cwillu <cwillu@cwillu.com>
Subject: Re: kernel oops -> no mount (different problem than others)
Date: Thu, 18 Aug 2011 18:52:08 -0600
Message-ID: <CAE5mzvg9Yd2qSrpSqKTNmu08z83JmgYtGZmuLg6aYGLMei26AQ@mail.gmail.com>
References: <CAO2p3yF57i2MeszoUHnFy3W-S_Dm-bMHJzY2GYULgxnFCS34Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Liam <liam.bulkley@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO2p3yF57i2MeszoUHnFy3W-S_Dm-bMHJzY2GYULgxnFCS34Hg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

You might try mounting it "-o ro" as a stopgap to regain readonly access.

Judging from the bootlog, the error itself appears to be enospc.  In
which case there's no already-available quick fix; I expect a
developer to chime in any second now :p

> From the logs it is listing a transid error but NOT that it is
> expecting a different one, simply
>
> device label 1TB devid 1 transid 248472 /dev/sdb

That particular line is the normal listing of devices, which is
expected and completely normal.
