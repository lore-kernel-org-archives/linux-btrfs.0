Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62045 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaICSxj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 14:53:39 -0400
Received: by mail-vc0-f178.google.com with SMTP id la4so9201454vcb.23
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Sep 2014 11:53:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADw2B2Ny_RV12AH49QLX2TVXZq9-vLaYecACpi20UDqxDau=Yw@mail.gmail.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
	<08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
	<CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
	<5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com>
	<CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
	<540617DE.5070605@gmail.com>
	<CADw2B2M+WSbCyphH3Y=5w8JyMHYe7sL_MdvScy9NLPS3PbRHiQ@mail.gmail.com>
	<88B7E732-0EB2-422C-B5C7-950E483C2E71@colorremedies.com>
	<9437B859-6FD7-4971-935A-E29EFBB7B261@colorremedies.com>
	<CADw2B2Ny_RV12AH49QLX2TVXZq9-vLaYecACpi20UDqxDau=Yw@mail.gmail.com>
Date: Wed, 3 Sep 2014 20:53:38 +0200
Message-ID: <CAFvQSYSuT53mP=_WszkffvhcsEAYEaS6m1Ycp=p=yUp3eX3pew@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: Clemens Eisserer <linuxhippy@gmail.com>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Richard,

> It is interesting that for me the number of extents before and after
> bcache are essentially the same.
>
> The lesson here for me there is that the fragmentation of a btrfs
> nodatacow file is not mitigated by bcache. There seems to be nothing I
> can do to prevent that fragmentation, and may in fact be expected
> behavior.

This is to be expected - bcache behaves like a single, transparent
block device - so for btrfs it doesn't matter whether you run on a
"real" device or a bcache one.
The performance increase is expected, however ;)

Best regards, Clemens
