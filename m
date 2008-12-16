From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Btrfs trees for linux-next
Date: Tue, 16 Dec 2008 02:39:57 +0100
Message-ID: <ac3eb2510812151739m1dc16d60u934c1ca02d45b401@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
	 <1229391447.27573.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Andreas Dilger" <adilger@sun.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1229391447.27573.6.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2008 at 02:37, Chris Mason <chris.mason@oracle.com> wrote:
> On Mon, 2008-12-15 at 23:55 +0100, Kay Sievers wrote:
>> On Mon, Dec 15, 2008 at 22:03, Andreas Dilger <adilger@sun.com> wrote:
>> > On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
>> >> The multi-device code uses a very simple brute force scan from userland
>> >> to populate the list of devices that belong to a given FS.  Kay Sievers
>> >> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
>> >> required for single device filesystems).
>> >
>> > This should use libblkid to do the scanning of the devices, and it can
>> > cache the results for efficiency.  Best would be to have the same LABEL+UUID
>> > for all devices in the same filesystem, and then once any of these devices
>> > are found the mount.btrfs code can query the rest of the devices to find
>> > the remaining parts of the filesystem.
>>
>> Which is another way to do something you should not do that way in the
>> first place, just with a library instead of your own code.
>>
>
> Well, its the same library everyone else is using to do things they
> shouldn't be doing ;)

Util-linux-ng can be configured to use libvolume_id and udev data, and
it's not used in SUSE and Ubuntu for exactly the reason mentioned. :)

Kay
