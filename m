From: Alli Quaknaa <alquaknaa@gmail.com>
Subject: Re: Restoring BTRFS partition
Date: Tue, 20 Apr 2010 22:25:34 +0000
Message-ID: <q2u8c113a261004201525kebe2462agaca1d5fb81773cef@mail.gmail.com>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
	 <20100420155538.GB3634@laptop.oracle.com>
	 <20100420165049.GA6352@flcl.lan>
	 <r2x8c113a261004201014v71b6bf3dy9535bb9ac2035d6e@mail.gmail.com>
	 <r2o8c113a261004201113gf771574eu35db1b0d916cdfd8@mail.gmail.com>
	 <20100420203017.GA4532@lelouch.nomadic.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Alli Quaknaa <alquaknaa@gmail.com>,
	Wengang Wang <wen.gang.wang@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100420203017.GA4532@lelouch.nomadic.ncsu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Oh, thank you very much!

I think I have found the real superblock you are talking about, but
I'm afraid I may have written something in the first 64MiB. Is there a
chance btrfsck will recover it?

Also, I think there's gotta be a better way to manipulate those huge
files then dd and hexedit for examination - I'd like to take the raw
file, open it in some hex editor and be able to cut of some of it's
beginning - I can't seem to be able to do it with hexedit. Is there a
tool you'd recomment?

al-Quaknaa
