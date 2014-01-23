Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaAWOlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 09:41:09 -0500
Date: Thu, 23 Jan 2014 15:41:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Joshua =?iso-8859-1?Q?Sch=FCler?= <joshua.schueler@gmail.com>
Cc: Miguel =?iso-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send 3.11 vs 3.12
Message-ID: <20140123144107.GN6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52E0DF6B.2080200@friendlyvirus.org>
 <52E10B06.4080703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <52E10B06.4080703@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 23, 2014 at 01:28:54PM +0100, Joshua Schüler wrote:
> btrfs guarantees backward compatibility since 3.13(?), but never
> guaranteed forward compatibility.

Isnt' this the opposite way? Forward means that old fs will be mountable
on a newer kernel.

I don't know what you mean by 'backward compatibility is guaranteed
since 3.13'. There are some features that get turned on automatically if
used for the first time, but not all of them prevent mounting on an
older kernel. Exmaple is the uuid tree, "generation v2" that's been
introduced with send. Older kernel ignores the changes and newer kernel
is usually able to recognize that the data are not all-ok and recovers
itself or allows the user to do so manually.

> So it is not yet supported to mount the fs with an older kernel once
> it was mounted with a newer one.

That's right, but in practice is not that bad.

> Especially when using features that are under heavy development right now.

Which features do you mean? Once a feature is introduced, the format
and incompatibility bits should not change. The code may change, and
does of course, but always in a compatible way.
