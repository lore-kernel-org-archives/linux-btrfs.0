From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Snapper packages for Ubuntu
Date: Tue, 10 Apr 2012 20:08:15 +0700
Message-ID: <CAG1y0scsfBjVBAL8EQFKJGoR=Dm2K11E8MJLcmqq=gckb0kG2g@mail.gmail.com>
References: <CAG1y0sdbtPB+9MxmzTuBD3kSe18kaU-fkfutNCg97jXHaQeCjQ@mail.gmail.com>
	<20120410115022.GB24057@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410115022.GB24057@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 6:50 PM, Arvin Schnell <aschnell@suse.de> wrote:
> On Tue, Apr 10, 2012 at 05:37:38PM +0700, Fajar A. Nugraha wrote:
>> Hi,
>>
>> I've created snapper packages for Ubuntu, available on
>> https://launchpad.net/~snapper/+archive/stable. For those new to
>> snapper, it's a tool for managing btrfs snapshots
>> (http://en.opensuse.org/Portal:Snapper). It depends on libblocxx

> libblocxx is not required for snapper anymore since about a
> month. It's checked during configure.

You're right. I just tested it, and not having libblocxx during
compilation results in less dependencies (namely libblocxx itself,
plus libssl, libcrypto, and libpcre).

What functionality, if any, is not available when not using libblocxx?
Since it's still used when present during configure, I assume it's
good for something.

Thanks.

Fajar
