From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: zero-length files in snapshots
Date: Sat, 13 Feb 2010 11:26:09 -0800
Message-ID: <93cdabd21002131126v4b4d3c1ei2a747a7a5de7b1c8@mail.gmail.com>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	 <m38wazywow.fsf@pullcord.laptop.org>
	 <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
	 <20100212151940.GA4191@localhost.localdomain>
	 <93cdabd21002120818g4c47e2b6k3083a368286651e5@mail.gmail.com>
	 <20100212162207.GB4191@localhost.localdomain>
	 <93cdabd21002120827k493a4c1ao2ba4b6840f2ab427@mail.gmail.com>
	 <20100212163246.GC4191@localhost.localdomain>
	 <93cdabd21002120913h1b1eaa2cke8941aa8557b66f3@mail.gmail.com>
	 <20100213112540.GB23512@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100213112540.GB23512@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2010 at 3:25 AM, Sander <sander@humilis.net> wrote:
> Mike Fedyk wrote (ao):
>> On Fri, Feb 12, 2010 at 8:32 AM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > Creating a file is a metadata operation, and _any_ metadata operat=
ion has to be
>> > committed to disk when the transaction commits in order to maintai=
n a coherent
>> > fs. ??Thanks,
>>
>> What I still don't understand though is that the create could have
>> taken up to 30 seconds to commit and the same for the few bytes of
>> data, but a few ms later a snapshot was made and the metadata change
>> was there and the data change was not. =C2=A0Could it have happened =
that
>> the snapshot would not have the newly created file and this was just=
 a
>> timing issue that should not be relied upon?
>>
>> I'm just wondering why that file was there at all.
>
> I would say that is because the moment the file got created, the
> resulting metadata was commited immediately. The data not yet.
>

Josef explained it to me on IRC.  Meta-data changes like file creation
get added to the current transaction and snapshots start a new
transaction so that is why the empty file is in the snapshot.

The file is empty because with delayed allocation, the data has not
hit the filesystem yet and thus has no representation in filesystem
operations like snapshots.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
