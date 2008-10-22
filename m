From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:04:10 +0200
Message-ID: <48FF32DA.2010103@waechter.wiz.at>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <20081021182710.a12f4914.skraw@ithnet.com>	 <1224611383.27474.140.camel@think.oraclecorp.com>	 <20081022141906.f6529c6d.skraw@ithnet.com> <1224683433.6448.36.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224683433.6448.36.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2008 3:50 PM, Chris Mason wrote:

> Let me reword my answer ;).  The next write will always succeed unles=
s
> the drive is out of remapping sectors.  If the drive is out, it is on=
ly
> good for reads and holding down paper on your desk.

I have a fairly new SATA disk with about 3000 hours of 24/7 duty
(very light load), 0 remapped sectors and 8 consecutive sectors with
read/write errors. Still, it did not perform remapping facing heavy
writes on the bad sectors. Now what? For whatever reason, remapping
not always works (or mine was produced with a total of zero
remapping sectors=E2=80=A6).

- Matthias
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
