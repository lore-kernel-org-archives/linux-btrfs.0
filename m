From: cwillu <cwillu@cwillu.com>
Subject: Re: Writes in idle/How to debug filesystem activity
Date: Tue, 30 Aug 2011 01:06:41 -0600
Message-ID: <CAE5mzvjK80AM=cpmTbxFyV-vU8G9OQmSbBAQo_16NVCe1KsLMg@mail.gmail.com>
References: <4E5C8A20.7030604@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jonas@lophus.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5C8A20.7030604@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

> There was once a similar thread about this issue; unfortunately, without any
> constructive answers:
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/10840

I believe sync does a transaction commit every time.
