From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Mon, 11 Jul 2011 17:34:39 +0100
Message-ID: <chaz20110711163439.GB18391@seebyte.com>
References: <1310137241-sup-8158@shiny> <20110709170959.GC4294@yahoo.fr> <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com> <20110709203649.GE4294@yahoo.fr> <1310301809-sup-9903@shiny> <20110710183728.GB4277@yahoo.fr> <20110711090121.GA2537@yahoo.fr> <1310396262-sup-7882@shiny> <chaz20110711153556.GC23450@seebyte.com> <1310401526-sup-1289@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310401526-sup-1289@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-11 12:25:51 -0400, Chris Mason:
[...]
> > Also, when I resume the rsync (so it doesn't transfer the
> > already transfered files), it does BUG() again.
> 
> Ok, could you please send along the exact rsync command you were
> running?
[...]

I did earlier, but here it is again:

rsync --archive --xattrs --hard-links --numeric-ids --sparse --acls /src/ /dst/

Also with:

(cd /src && bsdtar cf - .) | pv | (cd /dst && bsdtar -xpSf - --numeric-owner)

-- 
Stephane

