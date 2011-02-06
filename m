From: Serdar Dere <serdar@serdar-dere.net>
Subject: How are b+-trees are useind in filesystems
Date: Sun, 06 Feb 2011 17:19:13 +0100
Message-ID: <4D4ECA01.5040501@serdar-dere.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am new here and I think this is not a real btrfs question but a 
general filesystem-btree question.
I want to know how I do these following things:
- How do I translate "/home/serdar/public_html" -> btree
- how do I know how files/directories are related to each other

I did these with useing a binary tree (not balanced)
where a node owns
name (char*)
value (void*) (was a inode structure)
first_child (pointer)
siblings (pointer)

I was looking for the name seperated with "/"
siblings are in the same directory
first_child is the subdir

for the esample above.
look at root the siblings for home
take his first_child
if first_child is serdar, than take its first_child, else look for 
siblings after finding serdar, take its first_child
if first_child is public_html take this and its value, else look for 
siblings.

I can't do this with b-trees, this is why I asking
I am at this time not interested in data, where it is stored, I can take 
void* for this.

I hope I could explain my problem.
I read many papers and presentations about b-trees most of them at 
btrfs-learning
but they are only btree related how they work and why they are 
interesting for filesystems, but not how to translate the problem above.

I hope you can help me there.

Greetings Serdar
