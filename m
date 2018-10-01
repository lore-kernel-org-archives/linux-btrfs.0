Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B58C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 19:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A672146D
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 19:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="ABYzu/rn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4A672146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbeJBCal (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 22:30:41 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:55625 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbeJBCaj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 22:30:39 -0400
Received: by mail-it1-f196.google.com with SMTP id c23-v6so13081117itd.5
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2018 12:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=URlwpu3ynk9H1YWy6j9JxeHSaUCtazfhpZAUg7ZV8K0=;
        b=ABYzu/rn5KGLzKpUakeH0guSqmeKViJGq+FD/kelDucjg272iy2gwIWMYb8Axn3ZBF
         E1je8mdmNWWnxfAHLkf8+QcrG3Xzfx//dko55w8A6bR4eiZJREv0BFkYtQ2Cgx53Uycl
         CndM6KWHfB7equTENyNCPY8sSa/P/rEuI4msCPjlIZ1jSCwQ+QMV3IS8elm41wPKSwdp
         oZ2uHjdnKsr56obgSn/TycVcpR52Ya3ZhcoJBwmunOuukb7hvfhojuJ6e02ur6gRCxiM
         aqkqwJo3BCJOxLzUl4tWeyngk5TsALfzFYjJyQ4kVZmih78Hf5g6n6Y5hU8RqQxjDpVU
         VPdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=URlwpu3ynk9H1YWy6j9JxeHSaUCtazfhpZAUg7ZV8K0=;
        b=cKbYkOac8s9Xdgs4mA1bSu3y5R+Jrkt2P4APGqkKle2AmZ7Nvo+FtT7F34n/BusLt8
         1HEjV4wE0i79wjTdfd+Hf7F4+rZ2XdKWRs7377dEL28DqZk1Q59Hg/CM56MCH9HESz0F
         E8BeEhIRBjv5oiy2nlUKILz1PTs96WLQh/yUrxCLcTa5bnWhx81L4xlhidcvNsa0AE5U
         m9w/6JrgSTPc56CbRQORZLGNi1FuBFs22a9ORy1Aqot2amRGWDV4aumM8iwXW36camcp
         Cf3s41JaCXHt6YVVdWe7OIX3Z7e6Q1WxnALOwEZT8xSmmF/Sey1K2XOZR069bM/PZmti
         rasw==
X-Gm-Message-State: ABuFfohvHUHeKj4AekVY5T9nbwcgSqm5nUZ8BwLrdqahep52MyHkQuTZ
        Bfhgpz9Cm9tatMWT3wFWPW4AaD/z3/o=
X-Google-Smtp-Source: ACcGV63jX3VRxBO7VkVyL37ETaX6n6YxROzI+fWYVTOCw5crhNLy4v3L3YBnkF57XpjTB24D8+QL/w==
X-Received: by 2002:a24:2487:: with SMTP id f129-v6mr11224378ita.51.1538423476236;
        Mon, 01 Oct 2018 12:51:16 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id t24-v6sm5135331ite.12.2018.10.01.12.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 12:51:15 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: cross-fs copy support
Date:   Mon, 1 Oct 2018 13:51:09 -0600
In-Reply-To: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
To:     Eric Sandeen <sandeen@sandeen.net>
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
 <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
X-Mailer: Apple Mail (2.3273)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

=1D=08=1D=1DOn Oct 1, 2018, at 9:49 AM, Eric Sandeen =
<sandeen@sandeen.net> wrote:
>=20
>=20
> On 10/1/18 9:48 AM, Qu Wenruo wrote:
>>=20
>>=20
>> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
>>> I was wondering about the cross-fs copy through copy_file_range.
>>=20
>> The term "cross-fs" looks pretty confusing.
>>=20
>> If you mean "cross-subvolume", then it should work without problem in =
btrfs.
>>=20
>> If you mean reflink across two different file systems (not matter the
>> same fs type or not).
>> Then it's impossible to work.
>=20
> I believe Joshi is talking about vfs_copy_file_range() not
> vfs_clone_file range(), although _copy_ does call _clone_ if it can.
>=20
>> Reflink (clone_file_range) works by inserting data pointers into the
>> filesystem other than really copying the data.
>> Thus if the source is outside of the fs, it's really impossible to =
work,
>> as the source pointer/data is completely out of control of the dest =
fs.
>=20
> Yes, I would expect there to be problems with his modified kernel
> for a filesystem that supports clone_file_range, because
> vfs_copy_file_range() will clone if possible, and this should fail =
across
> filesystems.
>=20
> In general, though, I don't know for sure why we don't fall back to
> do_splice_direct() across filesystems, although the filesystems that
> implement their own ->copy_file_range ops may have their own,
> further restrictions within their implementations.
>=20
> This call /is/ documented in the manpage as only being valid for
> files on the same filesystem, though:
> http://man7.org/linux/man-pages/man2/copy_file_range.2.html

There was a patch to allow cross-mount copy for NFS, but it hasn't =
landed
yet.

Cheers, Andreas






--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAluyeq0ACgkQcqXauRfM
H+CA/BAAlqfHLiBffwXGdhOXxmPi4v2pdAwCq1EtDwY2FrQ9pouuSEwVc5WimoYA
8hPkLHmLw2DBwGon9YHgI90Or73VHWHY7hQDKJdU1kgo6BVSYDKSc2fj197DFuau
1SJbsERSn+VGlgoJgnzLsWUFbsl7jU8wXQAVh53zh1xHQtKrTWpfwlMO1/LmkO5M
FW5XIID7cE8iZHLMCdftciOufamoXiU1h1ILoWvMqmsL0lB8Ie2K2KKtw9EC6v2z
+CjMDPoNHIlbOFB+LIUKSTCNB064Sts3OUKF1EjfIYYoPAjM4JCuWU7rh5q1mv3o
gy7kxhx3IM8NpGDiGeUttCabdzqSMlY0VRyYLtTiqP5h6WkgHgrMkSb0zH26A2GZ
AKzzJZzUk24QMEaLoQPCYbN8EnwFwES/4vxGpeAmb3FAtSk2jDJiZ3QitTWbamSY
N2JydBps2Y+pi8W66VPKse/0u7REk9B79JSyouuB2VlyCxwGPME+VGCpAoMumrIA
FUkYzp699AlMOwCCsdJocsVUfSCOnfwD2sU73n7ytBvqyKF4LaGN1q6VMxaWvZAf
rM22YDLk3ATvYF2hp+hAzVJrVfEcPY+nadhUuFRt4AvgFrql56rGNEJzJ1e5kbe8
f2BgJ6dQV09n3zywL7O5nLE4b1BMHDl4jGkiPeKB+COydXzj9Pw=
=pSPg
-----END PGP SIGNATURE-----

--Apple-Mail=_6FD6155E-4B53-4E0B-BBB4-240C9582FC05--
