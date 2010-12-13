From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 19:20:08 +0100
Message-ID: <20101213182008.GB17928@mother>
References: <1292174654.11248.10.camel@paddy-desktop>
 <4D05630E.7070809@bobich.net>
 <1292260671.11248.609.camel@paddy-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292260671.11248.609.camel@paddy-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 13, 2010 at 05:17:51PM +0000, Paddy Steed wrote:
> So, no-one has any idea's on how to implement the cache. Would making=
 it
> all swap work, does to OS cache files in swap?

  Quite the opposite.  Too many people have ideas for SSD-as-cache in L=
inux,
in non particular order:
=E2=80=94 bcache
=E2=80=94 cleancache=20
=E2=80=94 btrfs temperature tracking
=E2=80=94 dm-hstore
=E2=80=94 dm-cache / flashcache

  Patches are in various states of implementation, some with explicit b=
trfs
support.  There's no clear winner at this time, but some of above solut=
ions
are shipped in distro kernels.

--=20
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
