From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: Still ENOSPC problems with 2.6.35-rc3
Date: Thu, 17 Jun 2010 15:46:00 +0200
Message-ID: <201006171546.00979.johannes.hirte@fem.tu-ilmenau.de>
References: <201006161948.26611.johannes.hirte@fem.tu-ilmenau.de> <201006170156.54551.johannes.hirte@fem.tu-ilmenau.de> <AANLkTikL6C9Ize1K-Hixsb9PEePezAQDR7FbQ7EemiRX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikL6C9Ize1K-Hixsb9PEePezAQDR7FbQ7EemiRX@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 17 Juni 2010, 02:47:07 schrieb Yan, Zheng:
> On Thu, Jun 17, 2010 at 7:56 AM, Johannes Hirte
> 
> <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > Am Donnerstag 17 Juni 2010, 01:12:54 schrieb Yan, Zheng:
> >> On Thu, Jun 17, 2010 at 1:48 AM, Johannes Hirte
> >> 
> >> <johannes.hirte@fem.tu-ilmenau.de> wrote:
> >> > With kernel-2.6.34 I run into the ENOSPC problems that where reported
> >> > on this list recently. The filesystem was somewhat over 90% full and
> >> > most operations on it caused a Oops. I was able to delete files by
> >> > trial and error and freed up half of the filesystem space. Operation
> >> > on the other files still caused an Oops.
> >> > 
> >> > For 2.6.35 there went some patches in, that addressed this problem.
> >> > Sadly they don't fix it but only avoid the Oops. A simple 'ls' on
> >> > this filesystem results in
> >> 
> >> To avoid ENOSPC oops, btrfs in 2.6.35 reserves more metadata space for
> >> system use than older btrfs. If the FS has already ran out of metadata
> >> space, using btrfs in 2.6.35 doesn't help.
> >> 
> >> Yan, Zheng
> > 
> > So how can this be fixed/avoided? There must be some free metadata space,
> > since I was able to delete files, more than 20Gig, mostly small files.
> > Also from my understanding, when freeing space by deleting files,
> > metadata space should be freed. Or do I get something wrong here?
> > 2.6.35 does change something, since I can delete more files, where 2.6.34
> > does Oops. But you're right, it doesn't help at all. So, where is this
> > space and why it can't be used?
> 
> what will happen if you keep deleting files using 2.6.35?

With 2.6.35 I'm able to continue deleting files, even those where 2.6.34 would 
Oops. It's slow and give me many of this warnings in dmesg but they get 
deleted. I didn't tried it to the end, but I can do if you want. I've saved 
the affected filesystem to a separate partition, so I can test with it.

regards,
  Johannes
