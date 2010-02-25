From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: btrfs no csum found for inode X start 0
Date: Thu, 25 Feb 2010 15:21:51 -0800
Message-ID: <93cdabd21002251521m694831bel9b1a038b9fdd16dc@mail.gmail.com>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
	 <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
	 <23a15591002251252w5b35e761t5311f3bd569b9d41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591002251252w5b35e761t5311f3bd569b9d41@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 12:52 PM, Leszek Ciesielski <skolima@gmail.com> wrote:
> I have changed the btrfs code to ignore checksum failures and now I
> can read files correctly from the filesystem. Also, moving them onto
> another volume and then back into btrfs fixes the checksums and no
> more errors are reported for the file in question.
>
> Quick and dirty code I used for getting my files out:

Yes, but did you verify your data?
