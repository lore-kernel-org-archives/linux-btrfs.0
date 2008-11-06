From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Checksum and transform layering
Date: Thu, 06 Nov 2008 17:31:53 +0100
Message-ID: <82ej1oiznq.fsf@mid.bfk.de>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Gregory Maxwell" <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com> (Gregory Maxwell's message of "Thu, 6 Nov 2008 01:34:55 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

* Gregory Maxwell:

> I noticed in the compression support that the checksum is over the
> uncompressed data.
>
> While this has the advantages that the checksum does not have to be
> changed as transformations are changed and the system might catch
> errors in the compression layer, this design decision will be
> problematic if/when encryption is supported:  Plaintext checksums
> would leak substantial amounts of information about the content of
> files.

Would this be an issue if metadata (including file names) were
encrypted as well?

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
