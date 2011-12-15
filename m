From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: What is best practice when partitioning a device that holds one
 or more btr-filesystems
Date: Wed, 14 Dec 2011 16:42:48 -0800
Message-ID: <CABsxX9K15tyQRXOWtLci94jfyJjtTZh9eRf4ssBjK=yD8TVuXw@mail.gmail.com>
References: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
	<CAKcLGm-LZmyOKm4gegZDRYaq-DO-KW+5CCb_E7n8WvF0fEFCeQ@mail.gmail.com>
	<CAKsPgxG7yr3SzwJYdsS58dMxZ_DwWH6b1CLg0eXwDmfQNAY4XA@mail.gmail.com>
	<CA+WRLO98Je2J1SMZv0zVi1r1AfGFcnUCHKU=sJAsYDuUssqx8w@mail.gmail.com>
	<CAKsPgxEk8+WJ2dGpzO4WG=UcO9y8j6j_5nX4c5x6H=qbjVVAJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Wilfred van Velzen <wvvelzen@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKsPgxEk8+WJ2dGpzO4WG=UcO9y8j6j_5nX4c5x6H=qbjVVAJw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 1:42 PM, Wilfred van Velzen <wvvelzen@gmail.com> wrote:
> On Wed, Dec 14, 2011 at 9:56 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> On Thu, Dec 15, 2011 at 5:51 AM, Wilfred van Velzen <wvvelzen@gmail.com>
>> wrote:
>>>
>>> (I'm not interested in what early adopter users do when they are using
>>> rc kernels...)
>>
>> Yet your going to use a FS without a working fsck? That puts you in early
>> adopter territory to me.
>
> Yeah maybe. But I'm still not interested in it regarding partitioning! ;)
>
> But actually I decided not to use it for the production environment.
> The missing working fsck is one of the reasons.
> Although opensuse supports it and Suse Linux Enterprise Server 11 is
> going to support it with their next SP release in Februari, and Fedora
> might use it as default in their next release... Did I miss any?

MeeGo has been using btrfs by default right from the start. In the
current versions, we even install everything in a single btrfs
partition, and use 2 subvolumes (/home and /), and create a factory
reset snapshot of the / filesystem at installation.

Auke
