From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 22:19:52 +0200
Message-ID: <201110072219.52773.diegocg@gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com> <4E8F4EA9.4090108@shiftmail.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Chester <somethingsome2000@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8F4EA9.4090108@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Viernes, 7 de Octubre de 2011 21:10:33 Asdo escribi=F3:
> failures, but you can always mount by rolling back to a previous=20
> uberblock, showing an earlier view of the filesystem, which would be=20
> consistent.

This is already available in Btrfs, command btrfsck -s.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
