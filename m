From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 13:31:37 -0400
Message-ID: <48FE11F9.7040700@gmail.com>
References: <20081021132322.271ad728.skraw@ithnet.com> <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com> <20081021171513.GA8799@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021171513.GA8799@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Tue, Oct 21, 2008 at 07:01:36PM +0200, Stephan von Krawczynski wrote:
>   
>> Sure, but what you say only reflects the ideal world. On a file service, you
>> never have that. In fact you do not even have good control about what is going
>> on. Lets say you have a setup that creates, reads and deletes files 24h a day
>> from numerous clients. At two o'clock in the morning some hd decides to
>> partially die. Files get created on it, fill data up to errors, get
>> deleted and another bunch of data arrives and yet again fs tries to allocate
>> the same dead areas. You loose a lot more data only because the fs did not map
>> out the already known dead blocks. Of course you would replace the dead drive
>> later on, but in the meantime you have a lot of fun.
>> In other words: give me a tool to freeze the world right at the time the
>> errors show up, or map out dead blocks (only because it is a lot easier).
>>     
>
> When modern disks can't solve the problems with their internal driver
> remapping anymore you better replace it ASAP as it is a very strong
> disk failure indication.  Last years FAST has some very interesting
> statitics showing this in the field.
>   

Doing proactive drive pulls is kind of a black art, but looking for 
*lots* of remapped sectors is always a pretty reliable clue. Note that 
modern S-ATA disks might have room to remap 2-3 thousand sectors, so you 
should not worry too much about a handful (say 20 or so). Sometimes the 
remapping happens because of transient things (junk on the platter, 
vibrations, out of spec temperature range, etc) so your drive might be 
perfectly healthy.

If you have remapped a big chunk of the sectors (say more than 10%), you 
should grab the data off the disk asap and replace it. Worry less about 
errors during read, writes indicate more serious errors.

The file system should not have to worry about remapping sectors 
internally, by the time writes fail and you have consumed all remapped 
sectors, you should definitely be in read-only mode and well on the way 
to replacing the disk :-)

ric

