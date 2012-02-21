From: David Sterba <dave@jikos.cz>
Subject: Re: Problems Implementing Snappy Patches
Date: Tue, 21 Feb 2012 13:03:23 +0100
Message-ID: <20120221120323.GG1046@twin.jikos.cz>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 04:46:00PM -0600, Mitch Harder wrote:
> I've been trying to test the snappy compression patches, but I'm
> getting corruptions when trying to use snappy as built on my system.

I went through the original C++ implementation (svn release r52) and
compared it to the C implementation. I did not see any problems with it,
it's direct transformation from C++ -> C, nothing like off-by-one
somewhere or typos in condition expressions. No clue where the
corruption comes from.


david
