From: Sander <sander@humilis.net>
Subject: Re: zero-length files in snapshots
Date: Sat, 13 Feb 2010 12:25:40 +0100
Message-ID: <20100213112540.GB23512@attic.humilis.net>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
 <m38wazywow.fsf@pullcord.laptop.org>
 <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
 <20100212151940.GA4191@localhost.localdomain>
 <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
 <20100212162207.GB4191@localhost.localdomain>
 <93cdabd21002120827k493a4c1ao2ba4b6840f2ab427@mail.gmail.com>
 <20100212163246.GC4191@localhost.localdomain>
 <93cdabd21002120913h1b1eaa2cke8941aa8557b66f3@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002120913h1b1eaa2cke8941aa8557b66f3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mike Fedyk wrote (ao):
> On Fri, Feb 12, 2010 at 8:32 AM, Josef Bacik <josef@redhat.com> wrote:
> > Creating a file is a metadata operation, and _any_ metadata operation has to be
> > committed to disk when the transaction commits in order to maintain a coherent
> > fs. ??Thanks,
> 
> What I still don't understand though is that the create could have
> taken up to 30 seconds to commit and the same for the few bytes of
> data, but a few ms later a snapshot was made and the metadata change
> was there and the data change was not.  Could it have happened that
> the snapshot would not have the newly created file and this was just a
> timing issue that should not be relied upon?
> 
> I'm just wondering why that file was there at all.

I would say that is because the moment the file got created, the
resulting metadata was commited immediately. The data not yet.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
