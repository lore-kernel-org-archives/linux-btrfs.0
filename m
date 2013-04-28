Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56422 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3D1VOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Apr 2013 17:14:38 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so6674061iej.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Apr 2013 14:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvg9Gepsd=SNZPR_jeYo1NE=T1=EmbCKy0LsNdV4dsyKkw@mail.gmail.com>
References: <CAHgo1RLE6RuSvHsBrGUvmMv6f1kE12oNdMgAVtZ3mJMu+U-5fw@mail.gmail.com>
	<CAFWF=anMBZGRqbykcASeimq=SO=GXjipN5uJoi-LGvURONXDow@mail.gmail.com>
	<CAHgo1RJz6E0pX99t8boj1MvtcV=hUveBrUcA-cV5bjRO7EVK=A@mail.gmail.com>
	<CAFWF=anbQg07mDDQQSZSSN4JTEMS43vi2cfu3CuW35uxH=TbSA@mail.gmail.com>
	<CAHgo1R+A+n4TJj9fQ5HhOeeqZ943f+==gv8Ak9kFBhVZv7pXEw@mail.gmail.com>
	<CAFWF=amYEOnT=vu6VH6hn7uHr+0k6deseT+GrvJzZHNJb--ypA@mail.gmail.com>
	<CAHgo1RLoXHt0NdDo88VJa8Ua5j9Aum7-rbs_5GuHswhuOT8WmQ@mail.gmail.com>
	<CAFWF=a=K-vT_DEdtJEgm8tfk7YwiKp1Aan+SCfAi4d8KtLdxog@mail.gmail.com>
	<klk057$icn$1@ger.gmane.org>
	<CAE5mzvg9Gepsd=SNZPR_jeYo1NE=T1=EmbCKy0LsNdV4dsyKkw@mail.gmail.com>
Date: Sun, 28 Apr 2013 15:14:37 -0600
Message-ID: <CAE5mzvgam+u1c=eLKB06OrzPQJQGSqrNvY1noJ1dczGcyw-LoQ@mail.gmail.com>
Subject: Re: Btrfs performance problem; metadata size to blame?
From: cwillu <cwillu@cwillu.com>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[how'd that send button get there]

space_cache is the default, set by mkfs, for a year or so now.  It's
sticky, so even if it wasn't, you'd only need to mount with it once.
