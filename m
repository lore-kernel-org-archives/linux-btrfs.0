From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Benchmarking btrfs on HW Raid ... BAD
Date: Mon, 28 Sep 2009 08:17:59 +0000
Message-ID: <82tyynxz2g.fsf@mid.bfk.de>
References: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu> (Tobias Oetiker's message of "Mon\, 28 Sep 2009 10\:06\:07 +0200 \(CEST\)")
List-ID: <linux-btrfs.vger.kernel.org>

* Tobias Oetiker:

> Running this on a single disk, I get the quite acceptable results.
> When running on-top of a Areca HW Raid6 (lvm partitioned)
> then both read and write performance go down by at least 2
> magnitudes.

Does the HW RAID use write caching (preferably battery-backed)?

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
