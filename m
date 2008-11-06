From: Claudio Martins <ctpm@ist.utl.pt>
Subject: Re: Checksum and transform layering
Date: Thu, 6 Nov 2008 12:15:12 +0000
Message-ID: <200811061215.12486.ctpm@ist.utl.pt>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 06 November 2008, Gregory Maxwell wrote:
>
> While this has the advantages that the checksum does not have to be
> changed as transformations are changed and the system might catch
> errors in the compression layer, this design decision will be
> problematic if/when encryption is supported:  Plaintext checksums
> would leak substantial amounts of information about the content of
> files.  The system could be switched to a keyed cryptographic hash,

 Indeed. The most obvious (and quite trivial) attack one can do is buil=
d a=20
huge database of checksums for known files or chunks of files.

 AFAIK this has already been done by law enforcement/security agencies =
to=20
detect "illegal" files, so it's definitely an issue that would affect a=
ny=20
future encryption code implemented in btrfs.

Regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
