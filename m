From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1657!
Date: Sun, 31 Jul 2011 11:02:14 -0400
Message-ID: <CALJXSJqae-xGwASD3ABhqUm+8+2Ksxp1BzNon2d8jmeNHDLOOA@mail.gmail.com>
References: <CAHzCyiQs27_fX1ifnMEO=8asYZbYot794m5cFBByOnpADFAVyg@mail.gmail.com>
 <20110731105459.GA28326@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	"Providence M. SALUMU" <providence.salumu@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110731105459.GA28326@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 31, 2011 at 6:54 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> This looks like a corrupt log tree.

For my personnal information, isn't BTRFS supposed to checksum log
transactions too? How can it become corrupt?
