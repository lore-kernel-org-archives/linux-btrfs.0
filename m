From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: Re: Free space left
Date: 16 Jan 2010 20:46:19 +0100
Message-ID: <m3tyulq1dg.fsf@mobydick.mine.nu>
References: <20100116164120.47eceecd@simplux>
	<201001162010.37752.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: kreijack@gmail.com (Goffredo Baroncelli)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001162010.37752.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

        Hello,

kreijack@gmail.com (Goffredo Baroncelli) writes:
> Try btrfs-show
> [...]

How do you read this then:

Label: none  uuid: 27fafa43-7ad0-4e8a-ada8-36f73ef8984c
        Total devices 2 FS bytes used 79.63GB
        devid    2 size 111.79GB used 111.01GB path /dev/sdb
        devid    1 size 111.79GB used 111.03GB path /dev/sda

I'm pretty sure I created this fs with -d raid1 -m raid1!  Speaking
of which, is there a way to read a FS configuration: how can I tell
this FS really uses raid1 for both data and metadata?

The used column is surprising: if it's a mirror why 111.01 and
111.03?  And why all the space is being used anyway: I mean what's
the difference between the 79.63GB and 111.0[13]?

And the output of df is confusing too:
/dev/sdb             234441648  83501968 150939680  36% /space

It's reporting twice the total space but I think I remember looking
it up and that should be fixed in a future kernel version.
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
