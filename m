From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: fixing slow sync(2)
Date: Wed, 12 Oct 2011 14:36:27 -0400
Message-ID: <CAPL5yKeOMy+3TPmeXBpDJQLLOzfnH2st=OmW=b=s+Xzrc9Zzpw@mail.gmail.com>
References: <4E906B1F.6010609@dbservice.com>
	<20111008153553.GA25337@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomas Carnecky <tom@dbservice.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111008153553.GA25337@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 8, 2011 at 11:35 AM, Josef Bacik <josef@redhat.com> wrote:

> I think I fixed this, try my git tree
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

I wanted to Ack this as well - 3.1-rc4 was completely unusable when
firefox was running (30+ second pauses to read directories, btrfs
threads were constantly running, even the mouse was jerky due to the
load)

Built from your tree (fa5cf66) and everything works like it should
again.  No load, fast response to IO requests.
