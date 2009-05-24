From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Sun, 24 May 2009 09:27:00 +0200
Message-ID: <20090524072659.GA2225@cip.informatik.uni-erlangen.de>
References: <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com> <20090504162650.GD13777@cip.informatik.uni-erlangen.de> <49FF3DCD.40306@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Heinz-Josef Claes <hjclaes@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FF3DCD.40306@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Heinz,

> Hi, during the last half year I thought a little bit about doing dedup
> for my backup program: not only with fixed blocks (which is
> implemented), but with moving blocks (with all offsets in a file: 1
> byte, 2 byte, ...). That means, I have to have *lots* of comparisions
> (size of file - blocksize).  Even it's not the same, it must be very
> fast and that's the same problem like the one discussed here.

because I just stumbled across that, I wanted to let you know about an
interesting approach that NetAPP is using for its Virtual Tape Library:

http://www.netapp.com/us/communities/tech-ontap/vtl-dedupe.html

        Thomas
