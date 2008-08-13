From: btrfs-devel@arbitraryconstant.com
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 13:28:21 -0600 (MDT)
Message-ID: <55868.206.174.215.6.1218655701.squirrel@avalon.arbitraryconstant.com>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A32DDE.8070203@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Don't do it!!!
>
> OK, I know Chris has described some block sharing.  But I hate it.
>
> If I copy "resume" to "resume.save", it is because I want 2 copies
> for safety.  I don't want the fs to reduce it to 1 copy.  And
> reducing the duplicates is exactly opposite to Chris's paranoid
> make-multiple-copies-by-default.
>
> Now feel free to tell me I'm an idiot (other people do) :)

In situations where there's non-trivial benefits to some workloads, but
also non-trivial drawbacks, it strikes me as something that could be
enabled and disabled as a mount option, like data=ordered.

