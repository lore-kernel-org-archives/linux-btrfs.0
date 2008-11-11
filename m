From: Martin =?iso-8859-1?q?B=FCrger?= <mbuerger@edu.uni-klu.ac.at>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Tue, 11 Nov 2008 18:14:38 +0100
Message-ID: <200811111814.38911.mbuerger@edu.uni-klu.ac.at>
References: <4917FFB0.2000100@oracle.com> <200811110708.36712.mbuerger@edu.uni-klu.ac.at> <3d0408630811110057lec87365w1095f570d4bd55e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630811110057lec87365w1095f570d4bd55e5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 11 November 2008, Yan Zheng wrote:
> Hi Martin,
>
> Please try following patch. Thank you,
That fixed it.

Best wishes,
--=20
Martin B=FCrger
1024D/27C9019B@www.edu.uni-klu.ac.at/~mbuerger/key.asc
Key fingerprint =3D D10D 97EF 0C32 B337 5A12  0B6C 2D47 7575 27C9 019B
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
