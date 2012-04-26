From: David Sterba <dave@jikos.cz>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 13:53:26 +0200
Message-ID: <20120426115326.GO20982@twin.jikos.cz>
References: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
 <C7$h9m5PCXB@helmut.hullen.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C7$h9m5PCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 01:11:00PM +0200, Helmut Hullen wrote:
> I now use to delete about the first 10 MByte of the target disk via "dd  
> if=/dev/zero"

FYI, the minimal amount of data you need to rewrite is 4k:

dd if=/dev/zero of=/dev/ice bs=1k count=4 seek=64

david
