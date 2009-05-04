From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 4 May 2009 18:26:50 +0200
Message-ID: <20090504162650.GD13777@cip.informatik.uni-erlangen.de>
References: <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FF11EE.2060404@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric,

> I would not categorize it as offline, but just not as inband (i.e., you can 
> run a low priority background process to handle dedup).

> Offline windows are extremely rare in production sites these days and
> it could take a very long time to do dedup at the block level over a
> large file system :-)

let me rephrase, by offline I meant asynchronous during off hours.

> 1/3 is not sufficient for dedup in my opinion - you can get that with 
> normal compression at the block level.

1/3 is what gives me real time data of an production environment in a
mixed VM setup without compression.

        Thomas
