From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Fri, 26 Aug 2011 07:41:24 -0700
Message-ID: <20110826144124.GA17519@lulu.zabbo.net>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110825060632.GA9933@infradead.org>
 <20110825064039.GO3162@dastard>
 <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
 <20110826013528.GW3162@dastard>
 <CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@zeniv.linux.org.uk, dchinner@redhat.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> > Hole: a range of the file that contains no data or is made up
> > entirely of =A0NULL (zero) data. Holes include preallocated ranges =
of
> > files that have not had actual data written to them.

> No for me. A hole is made up of zero data? It's a strange definition
> for me.

It's a very natural definition for me.  It mirrors the behaviour of
read() of sparse data inside i_size that file system authors already
have to consider.

It's also a reminder for people that this interface is about avoiding
reading zeros.  Systems that track contents can do this for files that
had tons of zeros written.  The data is there but the app is
specifically asking us to skip it by using SEEK_DATA.

- z
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
