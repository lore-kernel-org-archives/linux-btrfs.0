Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44980 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2JaK5c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 06:57:32 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so894375pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 03:57:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
References: <508FB45B.9040101@gmail.com>
	<508FC26A.1010206@pepinghege.net>
	<CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
	<50904949.8010603@gmail.com>
	<20121030221412.GB11422@carfax.org.uk>
	<20121030221947.GC11422@carfax.org.uk>
	<50906702.1010608@gmail.com>
	<CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
	<CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
	<CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
	<CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
Date: Wed, 31 Oct 2012 04:57:32 -0600
Message-ID: <CAE5mzvjc2EfZ-+P55PukWmM7EduOdBephnuBGAe2JPKuOiQ0vg@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: cwillu <cwillu@cwillu.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: ching <lsching17@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 4:48 AM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
>>> i also dont see any benefit from inlining small files:
>
>>> with defaults (inlining small files):
>>> real    4m39.253s
>>> Data: total=10.01GB, used=9.08GB
>>> Metadata, DUP: total=2.00GB, used=992.48MB
>
>>> without inline:
>>> real    4m42.085s
>>> Data: total=11.01GB, used=10.85GB
>>> Metadata, DUP: total=1.00GB, used=518.59MB
>>
>> I suggest you take a closer look at your numbers.
>
> both use 12GiB in total and both need 280 seconds.
> am i missing something?

9.08GB + 992.48MB*2 == 11.02GB

10.85GB + 518MB*2 == 11.86GB

That's nearly a GB smaller.
